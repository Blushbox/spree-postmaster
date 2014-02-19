Spree::Admin::OrdersController.class_eval do
  def label
    begin
    	raise "not yet implemented"
    rescue Exception => e
      flash[:error] = e.message
      redirect_to :back
    end

    # send_file ... 
  end
end
