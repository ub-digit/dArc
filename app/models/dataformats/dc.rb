class Dataformats::DC < Dataformats::Xml

  def get_dc_value field
     @doc.xpath('//oai_dc:dc/dc:' + field).text
  end

  def datastream_name
     'DC'
  end

  def title= title
     write_or_create_element(Dataformats::Xml::Path.new(['oai_dc:dc', 'dc:title'], {'dc' => "http://purl.org/dc/elements/1.1/", 'oai_dc' => "http://www.openarchives.org/OAI/2.0/oai_dc/"}), title)
  end

  def title
     read_element('//oai_dc:dc/dc:title', {'dc' => "http://purl.org/dc/elements/1.1/", 'oai_dc' => "http://www.openarchives.org/OAI/2.0/oai_dc/"})
  end

  def pid= value
     # read only
  end

  def pid
     read_element('//oai_dc:dc/dc:identifier', {'dc' => "http://purl.org/dc/elements/1.1/", 'oai_dc' => "http://www.openarchives.org/OAI/2.0/oai_dc/"})
  end

  def id= value
     # read only
  end

  def id
     pid.sub(/^.*:/,'').to_i
  end

end
