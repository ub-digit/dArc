class Dataformats::Xml

  def initialize obj
     @obj = obj
  end

  def document_for_ds ds_name
     ds = @obj.datastreams[ds_name]
     Nokogiri::XML(ds.content.strip)
  end
end
