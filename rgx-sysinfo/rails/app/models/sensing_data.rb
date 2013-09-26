# /moat/v1/upload-yokoyama-sensing-ivi/sensingdata
class SensingData < MoatModel
  
  MODEL_NAME='sensingdata'

  def SensingData.remove_all(device_uid)
    while true
      uids = []
      list = find(:all, params: { limit: 500 }, device: device_uid) || [] # device: is a MoatModel class specific argument.
      if list.empty?
        break
      end
      list.each do |sd|
        uids.push(sd.uid)
      end
      delete(uids.join(','), params: {}, device: device_uid) # device: is a MoatModel class specific argument.
    end
  end
end