require 'spec_helper'

describe Spree::Admin::PostmasterSettingsController do
  stub_authorization!

  context '#edit' do
    it 'should assign a Spree::PostmasterConfiguration and render the view' do
      spree_get :edit
      assigns(:config).should be_an_instance_of(Spree::PostmasterConfiguration)
      response.should render_template('edit')
    end
  end

  context '#update' do
    config = Spree::PostmasterConfiguration.new
    config.preferences.each do |name, orig_val|
      case config.preference_type(name)
      when :integer
        it "should allow us to set the value of #{name}" do
          new_val = SecureRandom.random_number(100)
          spree_post :update, name => new_val
          Spree::PostmasterConfiguration.new.send("preferred_#{name}").should eq(new_val)
          response.should redirect_to(spree.edit_admin_postmaster_settings_path)
        end
      when :string
        it "should allow us to set the value of #{name}" do
          new_val = SecureRandom.hex(5)
          spree_post :update, name => new_val
          Spree::PostmasterConfiguration.new.send("preferred_#{name}").should eq(new_val)
          response.should redirect_to(spree.edit_admin_postmaster_settings_path)
        end
      when :boolean
        it "should allow us to switch the value of #{name}" do
          spree_post :update, name => !orig_val
          Spree::PostmasterConfiguration.new.send("preferred_#{name}").should eq(!orig_val)
          response.should redirect_to(spree.edit_admin_postmaster_settings_path)
        end
      end
    end

    it "doesn't product an error when passed an invalid parameter name" do
      spree_post :update, 'not_real_parameter_name' => 'not_real'
      response.should redirect_to(spree.edit_admin_postmaster_settings_path)
    end
  end
end