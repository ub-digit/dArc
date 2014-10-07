class Dataformats::EAD < Dataformats::Xml

  def datastream_name
     'EAD'
  end

  def titleproper= value
     write_to_path(Dataformats::Xml::Path.new(['e:ead', 'e:eadheader', 'e:filedesc', 'e:titlestmt', 'e:titleproper'], {'e' => "http://xml.ra.se/EAD"}), value)
  end

  def titleproper
    read_from_path(Dataformats::Xml::Path.new(['e:ead', 'e:eadheader', 'e:filedesc', 'e:titlestmt', 'e:titleproper'], {'e' => "http://xml.ra.se/EAD"}))
  end

  def abstract= value
    write_to_path(Dataformats::Xml::Path.new(['e:ead', 'e:archdesc', { :level => 'fonds' }, 'e:did', 'e:abstract'], {'e' => "http://xml.ra.se/EAD"}), value)
  end

  def abstract
    read_from_path(Dataformats::Xml::Path.new(['e:ead', 'e:archdesc', { :level => 'fonds' }, 'e:did', 'e:abstract'], {'e' => "http://xml.ra.se/EAD"}))
  end

  def unitid= value
    write_to_path(Dataformats::Xml::Path.new(['e:ead', 'e:archdesc', {:level => 'fonds'}, 'e:did', 'e:unitid', {:countrycode => 'SE', :repositorycode => 'GUB-SE'}], {'e' => "http://xml.ra.se/EAD"}), value)
  end

  def unitid
    read_from_path(Dataformats::Xml::Path.new(['e:ead', 'e:archdesc', {:level => 'fonds'}, 'e:did', 'e:unitid', {:countrycode => 'SE', :repositorycode => 'GUB-SE'}], {'e' => "http://xml.ra.se/EAD"}))
  end

  def unittitle= value
    write_to_path(Dataformats::Xml::Path.new(['e:ead', 'e:archdesc', {:level => 'fonds'}, 'e:did', 'e:unittitle'], {'e' => "http://xml.ra.se/EAD"}), value)
  end

  def unittitle
    read_from_path(Dataformats::Xml::Path.new(['e:ead', 'e:archdesc', {:level => 'fonds'}, 'e:did', 'e:unittitle'], {'e' => "http://xml.ra.se/EAD"}))
  end

  def unitdate= value
    write_to_path(Dataformats::Xml::Path.new(['e:ead', 'e:archdesc', {:level => 'fonds'}, 'e:did', 'e:unitdate'], {'e' => "http://xml.ra.se/EAD"}), value)
  end

  def unitdate
    read_from_path(Dataformats::Xml::Path.new(['e:ead', 'e:archdesc', {:level => 'fonds'}, 'e:did', 'e:unitdate'], {'e' => "http://xml.ra.se/EAD"}))
  end



  # create an empty eac document
  def create_empty
     EadGenerator.generate_empty
  end
end
