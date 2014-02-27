class Spree::Admin::PostmasterSettingsController < Spree::Admin::BaseController

  def edit
    @preferences_Postmaster = [:api_key, :default_weight, :default_length, :default_width, :default_height]
    @preferences_FromAddress = [:company, :contact, :address, :city, :state, :zip_code, :phone_number, :country]

    @config = Spree::PostmasterConfiguration.new
  end

  def update
    config = Spree::PostmasterConfiguration.new

    params.each do |name, value|
      next unless config.has_preference? name
      config[name] = value
    end

    redirect_to edit_admin_postmaster_settings_path
  end

end
