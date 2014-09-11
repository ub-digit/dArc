class DarcFedora
  attr_reader :id, :obj
  include ActiveModel::Validations
  
  def initialize id, obj
     @id = id
     @obj = obj

     @obj.models.each{ |m| check_model(m) }
     unless @validModel
       raise Rubydora::RecordNotFound, 'DigitalObject.find called for an object of the wrong type', caller
     end
  end

  def self.find id
  	fedora_connetion = Rubydora.connect Rails.application.config.fedora_connection
    self.new id,fedora_connetion.find(id)
    
  end

  def self.find_by_id
  end

  def self.all
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
end
