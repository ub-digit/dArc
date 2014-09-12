class Dataformats::Xml

  def initialize obj
     @obj = obj
     @doc = document_for_ds(datastream_name)
  end

  # returns the contents of a datastream as a parsed xml document
  def document_for_ds ds_name
     ds = @obj.datastreams[ds_name]
     if ds.has_content?
       Nokogiri::XML(ds.content.strip)
     end
  end

  # returns the name of the datastream for this format
  def datastream_name
  end

  # checks if this is a newly created object without xml contents
  def is_new?
     @doc == nil
  end

  # saves the xml data from the document to the datastream
  def save
     ds = @obj.datastreams[datastream_name]
     ds.mimeType='text/xml'
     ds.controlGroup='X'
     ds.dsLabel='EAC'
     ds.content=@doc.to_xml
     ds.save()
  end
  
  # returns the document as an xml string
  def to_xml
     @doc.to_xml
  end
end
