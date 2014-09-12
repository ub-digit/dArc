class DarcFedora
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

  def self.find id options={}
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

  def self.find_by_id id options={}
     self.find(id)
  rescue => error
    return nil	
  end

  def self.all options = {}
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
