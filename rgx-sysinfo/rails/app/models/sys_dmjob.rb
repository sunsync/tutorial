# /moat/v1/sys/dmjob
class SysDmjob < MoatModel
  self.prefix = "#{Moat::REST_PATH}/sys/"
  
  # For the nested arguments attribute
  class Arguments < MoatModel
  end
end