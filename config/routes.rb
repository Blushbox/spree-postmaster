Spree::Core::Engine.routes.draw do

	namespace :admin do

    resource :postmaster_settings, :only => ['show', 'update', 'edit']

    get 'orders/:order_id/label/:shipment_id', :to => "orders#label", :as => :shipping_label
  end
  
end
