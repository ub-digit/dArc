
# Module for defining methods called upon class definition
# Included in DarcFedora through extend
module DarcFedoraDSHandler

  # Takes adds a list of fields to hash, with its' corresponding dataformat
  # Usage: attr_datastream :dc, :title, :description generates hash {:title => :dc, :description => :dc}
  def attr_datastream(dataformat, *args)
    @@attr_fields_datastream ||= {}
    args.each do |arg|
      @@attr_fields_datastream[arg] = dataformat
    end
  end

  # Creates a scope named after the first given parameter
  # Scope then defines methods for getting and setting values in the object
  # Usage: scope :brief, :title, :description defines scope :brief for fields: :title, :description
  def scope(scope_name, *args)
    scope_fields = args

    # Defines method 'scope_name'_load (ie. brief_load)
    # Load method sets all fields defined in scope, using the given dataformat class
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

    # Defines method 'scope_name'_save (ie. brief_save)
    # Save method stores all fields defined in scope, using the given dataformat class
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
      return true
    end

    # Defines method 'scope_name'_as_json (ie. brief_as_json)
    # as_json method returns a hash containing all fields defined in scope
    define_method("#{scope_name}_as_json".to_sym) do
      json_data = {}
      scope_fields.each do |field|
        json_data[field] = instance_variable_get("@#{field}")
      end
      json_data
    end

    # Defines method 'scope_name'_from_json (ie. brief_from_json)
    # from_json method sets all fields defined in scope, based on a given json document
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

# Class for managing all model objects stored in fedora
# Uses generated methods defined in DarcFedoraDSHandler
# Uses as_json and from_json as the only get/set functionality
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
     unless @obj.models.include?("info:fedora/fedora-system:ContentModel-3.0")
       # ensure that the list of models includes the model for the runtime class
       unless @obj.models.include?( Models.get_id_for_model_name self.class.fedora_model_name )
         raise Rubydora::RecordNotFound, 'DigitalObject.find called for an object of the wrong type', caller
       end
     end
  end

  # Returns a rubydora connection object
  def self.fedora_connection
    @fedora_connection ||= Rubydora.connect Rails.application.config.fedora_connection
  end

  # Finds a record based on id, can take both numeric part of PID(ie. 17), as well as full PID-string(ie. 'darc:17')
  # Returns a DarcFedora object or raises an exception
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
    
    self.new string_id,fedora_connection.find(string_id),scope
  end

  # Finds a record based on id, can take both numeric part of PID(ie. 17), as well as full PID-string(ie. 'darc:17')
  # Returns a DarcFedora object or returns nil
  def self.find_by_id id, options={}
     self.find(id, options)
  rescue => error
    return nil	
  end

  # Returns an array of integer part of PID for all objects of current class
  def self.all options={}
    model_id =  Models.get_id_for_model_name self.fedora_model_name
    #puts "current model Name: #{model_id}"
    resp = fedora_connection.sparql("SELECT ?a WHERE { ?a <info:fedora/fedora-system:def/model#hasModel> <#{model_id}> }")
    #puts resp
    result = []
    resp.each do |r| 
      id = r.to_s.sub(/^info\:fedora\/darc\:/, '').to_i
      obj = self.find(id)
      result << obj 
    end
    return result
  end

  # Loads fields in current scope from its' respective dataformat class
  def load
    self.send("#{@scope}_load")
  end

  # Saves fields in current scope through its' respective dataformat class
  def save
    self.send("#{@scope}_save")
  end

  # Returns fields in current scope from its' respective dataformat class as a hash
  def as_json(opt = {})
    self.send("#{@scope}_as_json")
  end

  # Sets fields in current scope through its' respective dataformat class from a json document
  def from_json(json, opt = {})
    self.send("#{@scope}_from_json", json)
  end

  # Creates a dataformat object for given dataformat
  def dataformat_wrapper_create(datastream)
    @wrapper = DS_MAP[datastream].new(@obj)
  end

  # Unsets dataformat object
  def dataformat_wrapper_dispose
    @wrapper = nil
  end

  # Saves all fields included in dataformat object
  def dataformat_wrapper_save
    @wrapper.save
  end

  # Returns field value from dataformat object
  def dataformat_fetch(field)
    return @wrapper.send(field)
  end

  # Sets field value in dataformat object
  def dataformat_push(field, value)
    return @wrapper.send(field.to_s + '=', value)
  end

  # Returns field value of the DC datastream
  def get_dc_value name
     ds = @obj.datastreams['DC']
     doc = Nokogiri::XML(ds.content.strip)
     ele= doc.xpath('//oai_dc:dc/dc:' + name)
     ele.text
  end

  # Returns a complete Fedora ID- string from an integer value
  def self.numeric_id_to_fedora_id numeric_id
     Rails.application.config.namespace_prefix + numeric_id.to_s
  end

  # Returns the corresponding model name in Fedora
  def self.fedora_model_name
     name
  end
end
