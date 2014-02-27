require 'postmaster'

Spree::Admin::OrdersController.class_eval do
	
  def label
    begin
    	generate_label(params[:shipment_id])
    rescue Exception => e
      flash[:error] = e.message
      redirect_to :back
    end

  end

  private

  def clean_phone_number(number)
    number.gsub(/\+|\.|\-|\(|\)|\s/, '')
  end

  # quick test
  def generate_label(shipment_id)

		# test key...
		Postmaster.api_key = "tt_MzkyMTAwMTpOcE05YTU2eXpNc3J2ZFZfNFZraUM1RDFqT1k"

    shipment = Spree::Shipment.find_by_number(shipment_id)
    stock_location = shipment.stock_location
    order = shipment.order
		shipping_method = shipment.shipping_method
    weight = shipment.line_items.map{|i| i.variant.weight || 1}.sum 	# default to 1oz

		# when user will choose delivery type you create shipment
		result = Postmaster::Shipment.create(
		  :from => {
		    :company => "BlushBox, Inc.",
		    :contact => "Joe Smith",
		    :line1 => "206 E. 9th, 18th Floor",
		    :city => "Austin",
		    :state => "TX",
		    :zip_code => "78701-2518",
		    :phone_no => "512-920-6404",
		    :country => "US"
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
		  :service => "2DAY",
		  :package => {
		    :value => 55,
		    :weight => 1.5,
		    :length => 10,
		    :width => 6,
		    :height => 8,
		  },
		  :reference => "Order ##{order.id}"
		)
		
		puts result.inspect

		# store in your DB shipment ID for later use
		shipment_id = result.id

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
