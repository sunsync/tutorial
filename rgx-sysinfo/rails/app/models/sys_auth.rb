#
# A special purpose class for authentication of MOAT REST API
#
# /moat/v1/sys/auth
class SysAuth < ActiveResource::Base
  include MoatRest
  self.site = Moat::REST_URI

  # Override so that an instance field 'access_token' is passed.
  def destroy
    return if access_token.nil?
    connection.delete(element_path({ access_token: access_token }), self.class.headers)
  end
      
  # Override because .json extension is not required.
  def self.element_path(id, prefix_options = {}, query_options = nil)
    if prefix_options.empty?
      query_options = {
        a: Moat::APPLICATION_ID,
        u: Moat::API_CLIENT_ID,
        c: Moat::API_CLIENT_SECRET
      } if query_options.nil? || query_options.empty?
      "#{Moat::REST_PATH}/sys/auth#{query_string(query_options)}"
    else
      "#{Moat::REST_PATH}/sys/auth?token=#{prefix_options[:access_token]}"
    end
  end
end