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
      scope_fields.each do |field|
        # title:
        #  dataformat_fetch(:dc, :title)
        # startdate:
        #  dataformat_fetch(:eac, :startdate)
        ds_data = dataformat_fetch(@@attr_fields_datastream[field], field)
        instance_variable_set("@#{field}", ds_data)
      end
    end
    define_method("#{scope_name}_as_json".to_sym) do
      json_data = {}
      scope_fields.each do |field|
        json_data[field] = instance_variable_get("@#{field}")
      end
      json_data
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

     @obj.models.each{ |m| check_model(m) }
     unless @validModel
       raise Rubydora::RecordNotFound, 'DigitalObject.find called for an object of the wrong type', caller
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
  	fedora_connection = Rubydora.connect Rails.application.config.fedora_connection
    self.new string_id,fedora_connection.find(string_id)
  end

  def self.find_by_id id, options={}
     self.find(id)
  rescue => error
    return nil	
  end

  def self.all options={}
  end

  def load
    self.send("#{@scope}_load")
  end

  def as_json(opt = {})
    self.send("#{@scope}_as_json")
  end

  def dataformat_fetch(datastream, field)
    puts ["Calling dataformat_fetch", datastream, field] # DEBUG
    return DS_MAP[datastream].new(@obj).send(field)
  end

  def check_model m
     if m =~ /info:fedora\/fedora-system:ContentModel-3.0/ or m == @id
       @validModel = 1
       return nil
     end
     model = Model.find(m)
     if(model.get_dc_value('title').include? self.class.name)
       @validModel = 1
     end
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

end
