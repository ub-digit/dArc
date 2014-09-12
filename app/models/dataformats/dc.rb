class Dataformats::DC < Dataformats::Xml

  def get_dc_value field
     @doc.xpath('//oai_dc:dc/dc:' + field).text
  end

  def datastream_name
     'DC'
  end

end
