class AddPostmasterFieldsToShipment < ActiveRecord::Migration
  def up
    add_column :spree_shipments, :postmaster_id, :integer, :default => nil
    add_column :spree_shipments, :postmaster_label_url, :string, :default => ""
  end

  def down
    remove_column :spree_shipments, :postmaster_id
    remove_column :spree_shipments, :postmaster_label_url    
  end
end
