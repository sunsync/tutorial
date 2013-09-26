class Sensor
  SENSOR_MAX_DISPLAY_SENSING_DATA_LENGTH = 5

  def initialize(gateway_name, address)
    @gateway_name = gateway_name
    @address = address
    @data_array = []
  end

  def add_sensing_data(data)
    @data_array.push(data)
  end
  def address()
    return @address
  end

  def sensing_data_array()
    @data_array.sort! {| a, b | b.timestamp <=> a.timestamp }
    return @data_array[0, SENSOR_MAX_DISPLAY_SENSING_DATA_LENGTH]
  end

  def update_firmware()
    now = Time.new
    job = {
      job_service_id: Moat::BLINK_RGX_LED,
      name: @gateway_name,
      activated_at: now.rfc2822,
      expired_at: (now + 30.minutes).rfc2822,
      arguments: {
        led_id: @address
      }
    }
    SysDmjob.new(job).save
  end

end
