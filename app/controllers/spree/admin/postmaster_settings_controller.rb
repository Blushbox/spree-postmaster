class Spree::Admin::PostmasterSettingsController < Spree::Admin::BaseController

  def edit
    @preferences_Postmaster = [:api_key, :default_weight]
    @preferences_FromAddress = [:company]

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


