module DarcFedoraDSHandler
  def attr_datastream(dataformat, *args)
    @@attr_fields_datastream ||= {}
    args.each do |arg|
      @@attr_fields_datastream[arg] = dataformat
    end
  end

  def scope(scope_name, *args)
    scope_fields = args
    define_method("#{scope_name}_load".to_sym) do
      @@attr_fields_datastream.values.uniq.each do |ds|
        ds_scope_fields = scope_fields.select do |field| @@attr_fields_datastream[field] == ds end
        if !ds_scope_fields.empty? then dataformat_wrapper_create(ds) end
        ds_scope_fields.each do |field|
          ds_data = dataformat_fetch(field)
          instance_variable_set("@#{field}", ds_data)
        end
        if !ds_scope_fields.empty? then dataformat_wrapper_dispose end
      end
    end
    define_method("#{scope_name}_save".to_sym) do
      @@attr_fields_datastream.values.uniq.each do |ds|
        ds_scope_fields = scope_fields.select do |field| @@attr_fields_datastream[field] == ds end
        if !ds_scope_fields.empty? then dataformat_wrapper_create(ds) end
        ds_scope_fields.each do |field|
          ds_data = instance_variable_get("@#{field}")
          dataformat_push(field, ds_data)
        end
        if !ds_scope_fields.empty? then
          dataformat_wrapper_save
          dataformat_wrapper_dispose
        end
      end
    end
    define_method("#{scope_name}_as_json".to_sym) do
      json_data = {}
      scope_fields.each do |field|
        json_data[field] = instance_variable_get("@#{field}")
      end
      json_data
    end
    define_method("#{scope_name}_from_json".to_sym) do |json|
      json_data = JSON.parse(json)
      scope_fields.each do |field|
        if json_data[field.to_s] != nil then
          instance_variable_set("@#{field}", json_data[field.to_s])
        end
      end
    end
  end
end

class DarcFedora
  DS_MAP={
    dc: Dataformats::DC,
    eac: Dataformats::EAC
  }
  extend DarcFedoraDSHandler
  attr_reader :id, :obj
  include ActiveModel::Validations
  
  def initialize id, obj, scope="brief"
     @id = id
     @obj = obj
     @scope = scope

     # don't do the model check for content model objects
     unless @obj.models.include?("info:fedora/fedora-system:ContentModel-3.0") then
       # ensure that the list of models includes the model for the runtime class
       valid = @obj.models.include?( Models.get_id_for_model_name self.class.fedora_model_name )
       unless valid
         raise Rubydora::RecordNotFound, 'DigitalObject.find called for an object of the wrong type', caller
       end
     end
  end

  def self.find id, options={}
    case id
      when Integer
        string_id = numeric_id_to_fedora_id(id)
      when String
        string_id = id
      else
        raise ArgumentError, 'id must be numeric or a string', caller
    end
    
    # set the scope from options[:select] if present. default to :full 
    scope = :full
    if options.has_key? :select then
      scope = options[:select]
    end
    
  	fedora_connection = Rubydora.connect Rails.application.config.fedora_connection
    self.new string_id,fedora_connection.find(string_id),scope
  end

  def self.find_by_id id, options={}
     self.find(id, options)
  rescue => error
    return nil	
  end

  def self.all options={}
  end

  def load
    self.send("#{@scope}_load")
  end

  def save
    self.send("#{@scope}_save")
  end

  def as_json(opt = {})
    self.send("#{@scope}_as_json")
  end

  def from_json(json, opt = {})
    self.send("#{@scope}_from_json", json)
  end

  def dataformat_wrapper_create(datastream)
    @wrapper = DS_MAP[datastream].new(@obj)
  end

  def dataformat_wrapper_dispose
    @wrapper = nil
  end

  def dataformat_wrapper_save
    @wrapper.save
  end

  def dataformat_fetch(field)
    return @wrapper.send(field)
  end

  def dataformat_push(field, value)
    return @wrapper.send(field.to_s + '=', value)
  end

  def get_dc_value name
     ds = @obj.datastreams['DC']
     doc = Nokogiri::XML(ds.content.strip)
     ele= doc.xpath('//oai_dc:dc/dc:' + name)
     ele.text
  end

  def self.numeric_id_to_fedora_id numeric_id
     Rails.application.config.namespace_prefix + numeric_id.to_s
  end

  def self.fedora_model_name
     name
  end
end
