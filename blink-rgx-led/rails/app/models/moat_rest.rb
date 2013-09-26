#
# A mixin to be 'include'd by a model class having the capability of 
# generic MOAT REST API resource.
#
module MoatRest

  # Override as the response json keys are camelCase.
  def load(attributes, remove_root = false)
    super(to_underscore(attributes), remove_root)
  end
  
  def to_underscore(attributes)
    # camelCaseKey to camel_case_key
    attributes.keys.each do |k|
      new_key = k.to_s.underscore
      attributes[new_key] = attributes[k]
      attributes.delete(k) unless new_key == k
    end
    attributes
  end

  # Override as the request json keys must be camelCase.
  def as_json(options = nil)
    attributes = super(options)
    hash = attributes.each_value.first
    hash.keys.each do |k|
      new_key = k.to_s.camelize(:lower)
      val = hash[k]
      if val.is_a?(MoatRest)
        # Removes the root element
        hash[new_key] = val.as_json(options)
      else
        hash[new_key] = val
      end
      hash.delete(k) unless new_key == k
    end
    # Removes the root element
    hash
  end

  # Override as the method is used as an attribute accessor as well.
  def get(*args)
    return @attributes[:get] if args.empty?
    super(args)
  end

  # Override as the method is used as an attribute accessor as well.
  def put(*args)
    return @attributes[:put] if args.empty?
    super(args)
  end

  # Override as the method is used as an attribute accessor as well.
  def post(*args)
    return @attributes[:post] if args.empty?
    super(args)
  end

  # Override as the method is used as an attribute accessor as well.
  def delete(*args)
    return @attributes[:delete] if args.empty?
    super(args)
  end

end
