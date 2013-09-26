class RequestHistory < ActiveRecord::Base
  include MoatRest
  
  attr_accessible :uid, :device_id, :name, :status,
    :job_service_id, :session_id, :arguments, :description,
    :created_at, :activated_at, :started_at, :ended_at, :expired_at,
    :notification_type, :notification_uri
  
  def update_from(obj_or_attrs)
    attrs = to_underscore(obj_or_attrs)
    attrs['arguments'] = attrs['arguments'].to_json if attrs['arguments']
    update_attributes(filter(attrs))
    self
  end
  
  private
  def filter(attrs)
    new_attrs = {}
    attributes.keys.each do |sym|
      k = sym.to_s
      new_attrs[k] = attrs[k] if attrs[k]
    end
    new_attrs
  end
end
