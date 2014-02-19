Spree::Core::Engine.routes.draw do

	namespace :admin do
    get 'orders/:order_id/label/:shipment_id', :to => "orders#label", :as => :shipping_label
  end
  
end
