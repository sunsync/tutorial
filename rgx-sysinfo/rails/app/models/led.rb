require 'pp'

class Led
  
  def initialize(gateway_name)
    @gateway_name = gateway_name
  end

  def do_blink(command_type)
    now = Time.new
    job = {
      job_service_id: Moat::BLINK_RGX_LED,
      name: @gateway_name,
      activated_at: now.rfc2822,
      expired_at: (now + 30.minutes).rfc2822,
      arguments: {
        command_type: command_type
      }
    }
    pp job.to_json
    SysDmjob.new(job).save    
  end

  def start_blink()
    do_blink('start')
  end

  def stop_blink()
    do_blink('stop')
  end

end
