class DashboardController < ApplicationController
  
  def index
    @sensing_data = {}
    @sensors = {}
    @devices = SysDevice.find || []
    @delete_device_enabled = params[:delete_enabled] if params[:delete_enabled]
    @devices.each do |d|
      @sensing_data[d.name] = SensingData.find(:all, params: {
        offset: params[:offset], limit: params[:limit]
      }, device: d.uid) || [] # device: is a MoatModel class specific argument.
      @sensing_data[d.name].sort! {| a, b | a.address <=> b.address }
      child_sensors = Array.new(0)
      cur_sensor = nil
      @sensing_data[d.name].each do |data|
        if cur_sensor.nil? || cur_sensor.address != data.address
          cur_sensor = Sensor.new(d.name, data.address)
          child_sensors.push(cur_sensor)
        end
        cur_sensor.add_sensing_data(data)
      end
      @sensors[d.name] = child_sensors
    end
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

  def stop_blink
    led = Led.new(params[:name])
    led.stop_blink
    redirect_to action: 'index'    
  end

end
