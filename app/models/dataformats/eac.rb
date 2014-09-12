class Dataformats::EAC < Dataformats::Xml

  def datastream_name
     'EAC'
  end

  def authorized_forename= name
     if is_new?
       @doc = create_empty
     end
     
     @doc.xpath('//e:eac/e:condesc/e:identity/e:pershead[@authorized!=""]/e:part[@type="forename"]', 'e' => "http://xml.ra.se/EAC")[0].content=name
  end

  def authorized_forename
     if is_new?
       return nil
     end
     @doc.xpath('//e:eac/e:condesc/e:identity/e:pershead[@authorized!=""]/e:part[@type="forename"]', 'e' => "http://xml.ra.se/EAC")[0].text
  end

  def authorized_surname= name
     if is_new?
       @doc = create_empty
     end
     
     @doc.xpath('//e:eac/e:condesc/e:identity/e:pershead[@authorized!=""]/e:part[@type="surname"]', 'e' => "http://xml.ra.se/EAC")[0].content=name
  end

  def authorized_surname
     if is_new?
       return nil
     end
     @doc.xpath('//e:eac/e:condesc/e:identity/e:pershead[@authorized!=""]/e:part[@type="surname"]', 'e' => "http://xml.ra.se/EAC")[0].text
  end

  def type= type
     write_attribute('//e:eac/@type', {'e' => "http://xml.ra.se/EAC"}, type)
  end

  def type
     read_attribute('//e:eac/@type', {'e' => "http://xml.ra.se/EAC"})
  end

  def startdate= startdate
     if is_new?
       @doc = create_empty
     end
     
     #@doc.xpath('//e:eac/e:condesc/e:identity/e:pershead[@authorized!=""]/e:part[@type="surname"]', 'e' => "http://xml.ra.se/EAC")[0].content=name
  end

  def startdate
     if is_new?
       return nil
     end
     #@doc.xpath('//e:eac/e:condesc/e:identity/e:pershead[@authorized!=""]/e:part[@type="surname"]', 'e' => "http://xml.ra.se/EAC")[0].text
     ''
  end

  def enddate= enddate
     if is_new?
       @doc = create_empty
     end
     
     #@doc.xpath('//e:eac/e:condesc/e:identity/e:pershead[@authorized!=""]/e:part[@type="surname"]', 'e' => "http://xml.ra.se/EAC")[0].content=name
  end

  def enddate
     if is_new?
       return nil
     end
     #@doc.xpath('//e:eac/e:condesc/e:identity/e:pershead[@authorized!=""]/e:part[@type="surname"]', 'e' => "http://xml.ra.se/EAC")[0].text
     ''
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
