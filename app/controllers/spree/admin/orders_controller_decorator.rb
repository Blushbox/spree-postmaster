require 'postmaster'

Spree::Admin::OrdersController.class_eval do
	
  def label
    begin
    	generate_label(params[:shipment_id])
    	flash[:notice] = "Label successfuly generated"
    rescue Exception => e
      flash[:error] = e.message
    end
    redirect_to :back
  end

  private

  def clean_phone_number(number)
    number.gsub(/\+|\.|\-|\(|\)|\s/, '')
  end

  def generate_label(shipment_id)

		Postmaster.api_key = Spree::Postmaster::Config[:api_key]

    shipment = Spree::Shipment.find_by_number(shipment_id)
    stock_location = shipment.stock_location
    order = shipment.order
		shipping_method = shipment.shipping_method
		default_weight = Spree::Postmaster::Config[:default_weight]
    weight = shipment.line_items.sum do |i|
     	w = i.variant.weight
     	w = default_weight if w.blank? or weight <= 0     		
     	w * i.quantity
    end

		# when user will choose delivery type you create shipment
		result = Postmaster::Shipment.create(
		  :from => {
		    :company => Spree::Postmaster::Config[:company],
		    :contact => Spree::Postmaster::Config[:contact],
		    :line1 => Spree::Postmaster::Config[:address],
		    :city => Spree::Postmaster::Config[:city],
		    :state => Spree::Postmaster::Config[:state],
		    :zip_code => Spree::Postmaster::Config[:zip_code],
		    :phone_no => Spree::Postmaster::Config[:phone_number],
		    :country => Spree::Postmaster::Config[:country]
		  },
		  :to => {
		  	:company => order.ship_address.company,
		    :contact => "#{order.ship_address.firstname} #{order.ship_address.lastname}",
		    :line1 => order.ship_address.address1,
		    :line2 => order.ship_address.address2 || '',
		    :city => order.ship_address.city,
		    :state => order.ship_address.state_name || (order.ship_address.state.nil? ? "" : order.ship_address.state.abbr),
		    :zip_code => order.ship_address.zipcode.gsub(/\-|\s/, ''),
		    :phone_no => clean_phone_number(order.ship_address.phone == "(not given)" ? order.bill_address.phone : order.ship_address.phone),
		    :country => Spree::Country.find(order.ship_address.country_id).iso
		  },
		  :carrier => "usps",
		  :service => shipping_method.admin_name, # the internal name of each shipping method must match a valid postmaster.io service level, e.g.: 2DAY
		  :package => {
		    :value => order.item_total,
		    :weight => weight,
		    :length => nil || Spree::Postmaster::Config[:default_length],
		    :width => nil || Spree::Postmaster::Config[:default_width],
		    :height => nil || Spree::Postmaster::Config[:default_height],
		  },
		  :reference => "Order ##{order.id}"
		)
		
		# result.inspect example:
		# <Postmaster::Shipment:0x3fd7cf8555d4 id=5649050225344512> JSON: 
		# {"id":5649050225...,
		# "status":"Processing",
		# "tracking":["949990712345..."],
		# "cost":530,
		# "prepaid":true,
		# "service":"2DAY",
		# "package_count":1,
		# "created_at":1393523684,
		# "saturday":false,
		# "to":[["city","Austin"],["country","US"],["phone_no","512..."],["line1","123 ..."],["state","TX"],["contact","..."],["residential",true],["zip_code","78701"]],
		# "carrier":"usps",
		# "from":[["city","Austin"],["country","US"],["company","BlushBox, Inc."],["phone_no","512..."],["line1","101 Test Addy"],["state","TX"],["residential",true],["zip_code","78701"]],
		# "packages":[[["weight_units","LB"],["weight",1.0],["type","CUSTOM"],["value","174.0"],["height",4],["width",3],["length",2],
		# ["label_url","/v1/label/AMIfv97VnI7GRonSbx-1234...."],
		# ["dimension_units","IN"]]],"additional_data":{}}

		# store postmaster.io id, label url, and tracking #
		shipment.postmaster_id = result.id
		shipment.postmaster_label_url = result.packages.first.label_url
		shipment.tracking = result.tracking.first
		shipment.save!

		# # anytime you can extract shipment data
		# shipment = Postmaster::Shipment.retrieve(shipment_id)
		# #puts shipment.inspect

		# # or check delivery status
		# result = shipment.track()
		# #puts result.inspect

		# # you can cancel shipment, but only before being picked up by the carrier
		# result = shipment.void()
		# #puts result.inspect

	end
end
