#
# A base class for all MOAT IoT Developer Defined Models
#
class MoatModel < ActiveResource::Base
  include MoatRest

  mattr_accessor :guard, :sys_auth, :last_accessed
  self.guard = Mutex.new
  self.sys_auth = nil
  self.last_accessed = 0

  self.site = Moat::REST_URI
  self.prefix = "#{Moat::REST_PATH}/#{Moat::PACKAGE_ID}/"

  # Returns/Sets the authenticity token
  def self.auth_token
    now = Time.now
    self.guard.synchronize do
      unless self.sys_auth
        self.last_accessed = now
        self.sys_auth = SysAuth.find
      else
        if now - self.last_accessed > 60 * 25
          begin
            self.sys_auth.destroy
          rescue ActiveResource::UnauthorizedAccess
            # ignorable
          end
          self.sys_auth = SysAuth.find
        end
      end
    end
    self.sys_auth.access_token
  end
  
  # Override because of missing attribute values
  def method_missing(meth, *args, &block)
    super(meth, *args, &block)
  rescue
    nil
  end

  # Override to truncate sys_ prefix or to downcase the class name
  def self.element_name
    if sys?
      @element_name = model_name.element[4..-1]
    else
      @element_name = model_name.downcase
    end
  end

  # Override -> Always singular. The MOAT REST naming convention doesn't employ the plural form.
  def self.collection_name
    @collection_name = element_name
  end
  
  # Override so that a query result object, containing a JSON array, can be handled correctly.
  def self.instantiate_collection(collection, prefix_options = {})
    ary = collection
    ary = collection["array"] if collection.is_a?(Hash) && collection["array"]
    ary.collect! { |record| instantiate_record(record, prefix_options) }
  end
  
  # Override so that a query result object, containing a JSON array, can be handled correctly.
  def self.instantiate_record(record, prefix_options = {})
    return instantiate_collection(record["array"], prefix_options) if record["array"]
    new(record, true).tap do |resource|
      resource.prefix_options = prefix_options
    end
  end
  
  # Override in order to exclude the format extension
  def self.collection_path(prefix_options = {}, query_options = nil)
    if device_to_from(prefix_options).include?(:from)
      "#{device_to_from(prefix_options)[:from]}/#{query_string(query_options)}"
    else
      check_prefix_options(prefix_options)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}#{collection_name}#{query_string(query_options)}"
    end
  end
       
  # Override in order to exclude the format extension
  def self.element_path(id, prefix_options = {}, query_options = nil)
    if device_to_from(prefix_options).include?(:from)
      "#{device_to_from(prefix_options)[:from]}/#{URI.parser.escape id.to_s}#{query_string(query_options)}"
    else
      check_prefix_options(prefix_options)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}#{collection_name}/#{URI.parser.escape id.to_s}#{query_string(query_options)}"
    end
  end
  
  # Override in order to exclude the format extension and append an access token
  def self.new_element_path(prefix_options = {})
    if device_to_from(prefix_options).include?(:from)
      device_to_from(prefix_options)[:from]
    else
      "#{prefix(prefix_options)}#{collection_name}#{query_string}"
    end
  end

  protected
  # Override so to append an access token
  def self.query_string(options = nil)
    unless options.nil? || options.empty?
      "?#{options.to_query}&token=#{self.auth_token}" # @MoatRestAuth
    else
      "?token=#{self.auth_token}" # @MoatRestAuth
    end
  end
  
  def self.sys?
    model_name.element.start_with?("sys_")
  end
  
  def self.device_to_from(options)
    options[:from] = "#{Moat::REST_PATH}/sys/device/#{options[:device]}/#{Moat::PACKAGE_ID}/#{element_name}" if !sys? && options[:device]
    options
  end

  # Override so that the device UID prefix can be added.
  def self.find_every(options)
    super(device_to_from(options))
  end
  
  # Override so that the device UID prefix can be added.
  def find_one(options)
    super(device_to_from(options))
  end

end
