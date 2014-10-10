class Dataformats::EAD < Dataformats::Xml 

  def datastream_name
     'EAD'
  end

  def xml_schema
    return Pathname.new(Rails.root.to_s + "/app/assets/schemas/ead.xsd")
  end

  def titleproper= value
     write_to_path(Dataformats::Xml::Path.new(['e:ead', 'e:eadheader', 'e:filedesc', 'e:titlestmt', 'e:titleproper'], {'e' => "urn:isbn:1-931666-22-9"}), value)
  end

  def titleproper
    read_from_path(Dataformats::Xml::Path.new(['e:ead', 'e:eadheader', 'e:filedesc', 'e:titlestmt', 'e:titleproper'], {'e' => "urn:isbn:1-931666-22-9"}))
  end

  def abstract= value
    write_to_path(Dataformats::Xml::Path.new(['e:ead', 'e:archdesc', { :level => 'fonds' }, 'e:did', 'e:abstract'], {'e' => "urn:isbn:1-931666-22-9"}), value)
  end

  def abstract
    read_from_path(Dataformats::Xml::Path.new(['e:ead', 'e:archdesc', { :level => 'fonds' }, 'e:did', 'e:abstract'], {'e' => "urn:isbn:1-931666-22-9"}))
  end

  def unitid= value
    write_to_path(Dataformats::Xml::Path.new(['e:ead', 'e:archdesc', {:level => 'fonds'}, 'e:did', 'e:unitid', {:countrycode => 'SE', :repositorycode => 'GUB-SE'}], {'e' => "urn:isbn:1-931666-22-9"}), value)
  end

  def unitid
    read_from_path(Dataformats::Xml::Path.new(['e:ead', 'e:archdesc', {:level => 'fonds'}, 'e:did', 'e:unitid', {:countrycode => 'SE', :repositorycode => 'GUB-SE'}], {'e' => "urn:isbn:1-931666-22-9"}))
  end

  def unittitle= value
    write_to_path(Dataformats::Xml::Path.new(['e:ead', 'e:archdesc', {:level => 'fonds'}, 'e:did', 'e:unittitle'], {'e' => "urn:isbn:1-931666-22-9"}), value)
  end

  def unittitle
    read_from_path(Dataformats::Xml::Path.new(['e:ead', 'e:archdesc', {:level => 'fonds'}, 'e:did', 'e:unittitle'], {'e' => "urn:isbn:1-931666-22-9"}))
  end

  def unitdate= value
    write_to_path(Dataformats::Xml::Path.new(['e:ead', 'e:archdesc', {:level => 'fonds'}, 'e:did', 'e:unitdate'], {'e' => "urn:isbn:1-931666-22-9"}), value)
  end

  def unitdate
    read_from_path(Dataformats::Xml::Path.new(['e:ead', 'e:archdesc', {:level => 'fonds'}, 'e:did', 'e:unitdate'], {'e' => "urn:isbn:1-931666-22-9"}))
  end



  # create an empty eac document
  def create_empty
     EadGenerator.generate_empty
  end
end
