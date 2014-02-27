class Spree::PostmasterConfiguration < Spree::Preferences::Configuration

  preference :api_key, :string, :default => ""
  preference :default_weight, :integer, :default => nil
  preference :default_length, :integer, :default => nil
  preference :default_width, :integer, :default => nil
  preference :default_height, :integer, :default => nil
  preference :company, :string, :default => ""
  preference :contact, :string, :default => ""
  preference :address, :string, :default => ""
  preference :city, :string, :default => ""
  preference :state, :string, :default => ""
  preference :zip_code, :string, :default => ""
  preference :phone_number, :string, :default => ""
  preference :country, :string, :default => ""  

end
