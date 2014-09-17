class Dataformats::EAC < Dataformats::Xml

  def datastream_name
     'EAC'
  end

  def authorized_forename= name
     write_element('//e:eac/e:condesc/e:identity/e:pershead[@authorized!=""]/e:part[@type="forename"]', {'e' => "http://xml.ra.se/EAC"}, name)
  end

  def authorized_forename
     read_element('//e:eac/e:condesc/e:identity/e:pershead[@authorized!=""]/e:part[@type="forename"]', {'e' => "http://xml.ra.se/EAC"})
  end

  def authorized_surname= name
     write_element('//e:eac/e:condesc/e:identity/e:pershead[@authorized!=""]/e:part[@type="surname"]', {'e' => "http://xml.ra.se/EAC"}, name)
  end

  def authorized_surname
     read_element('//e:eac/e:condesc/e:identity/e:pershead[@authorized!=""]/e:part[@type="surname"]', {'e' => "http://xml.ra.se/EAC"})
  end

  def type= type
     write_attribute('//e:eac/@type', {'e' => "http://xml.ra.se/EAC"}, type)
  end

  def type
     read_attribute('//e:eac/@type', {'e' => "http://xml.ra.se/EAC"})
  end

  def startdate= value
     write_or_create_element(Dataformats::Xml::Path.new(['e:eac', 'e:condesc', 'e:desc', 'e:persdesc', 'e:existdesc', 'e:existdate', { :scope => 'begin' }], {'e' => "http://xml.ra.se/EAC"}), value)
  end

  def startdate
     read_element('//e:eac/e:condesc/e:desc/e:persdesc/e:existdesc/e:existdate[@scope="begin"]', {'e' => "http://xml.ra.se/EAC"})
  end

  def enddate= value
     write_or_create_element(Dataformats::Xml::Path.new(['e:eac', 'e:condesc', 'e:desc', 'e:persdesc', 'e:existdesc', 'e:existdate', { :scope => 'end' }], {'e' => "http://xml.ra.se/EAC"}), value)
  end

  def enddate
     read_element('//e:eac/e:condesc/e:desc/e:persdesc/e:existdesc/e:existdate[@scope="end"]', {'e' => "http://xml.ra.se/EAC"})
  end

  def biography= biography
     if is_new?
       @doc = create_empty
     end
     
     #@doc.xpath('//e:eac/e:condesc/e:identity/e:pershead[@authorized!=""]/e:part[@type="surname"]', 'e' => "http://xml.ra.se/EAC")[0].content=name
  end

  def biography
     if is_new?
       return nil
     end
     #@doc.xpath('//e:eac/e:condesc/e:identity/e:pershead[@authorized!=""]/e:part[@type="surname"]', 'e' => "http://xml.ra.se/EAC")[0].text
     ''
  end

  # create an empty eac document
  def create_empty
     EacGenerator.generate_empty('person')
  end
end
