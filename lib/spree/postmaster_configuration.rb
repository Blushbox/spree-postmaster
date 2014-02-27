class Spree::PostmasterConfiguration < Spree::Preferences::Configuration

  preference :api_key, :string, :default => ""
  preference :default_weight, :integer, :default => 0 # 16 oz./lb - assumes variant weights are in lbs
  preference :company, :string, :default => ""

end
