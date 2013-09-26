class DashboardController < ApplicationController
  
  def index
    @devices = SysDevice.find || []
    @delete_device_enabled = params[:delete_enabled] if params[:delete_enabled]
    @job_list = SysDmjob.find(:all) || []
  end
  
  def delete_device
    SysDevice.delete(params[:device_uid]) if params[:device_uid]
    redirect_to action: 'index'
  rescue
    flash[:error] = "Cancel the ongoing requests prior to removing the device."
    redirect_to action: 'index'
  end

  def cancel
    SysDmjob.delete(params[:uid]) if params[:uid]
    redirect_to action: 'index'
  rescue
    flash[:error] = "Nothing to cancel."
    redirect_to action: 'index'
  end
  
  def start_blink
    led = Led.new(params[:name])
    led.start_blink
    redirect_to action: 'index'
  end

end
