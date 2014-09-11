class Dataformats::DC < Dataformats::Xml

  def get_dc_value field
     document_for_ds('DC').xpath('//oai_dc:dc/dc:' + field).text
  end

end
