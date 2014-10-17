require 'nokogiri'
require 'json'

class Dfxml
  def self.from_file filename,diskimageid
    open(filename) do |dfxml_file|
	  xml = Nokogiri::XML(dfxml_file.read)
	  
	  objects = xml.xpath('.//d:fileobject', {'d' => 'http://www.forensicswiki.org/wiki/Category:Digital_Forensics_XML'})
	  file_infos = objects.map do |obj|

        obj_hash = fileobject_to_hash obj
        if obj_hash != nil then
          obj_hash = modify_file_object obj_hash
          ContentFileInfo.new(obj_hash.merge({'disk_image' => diskimageid}))
        end
	  end
	  
	  file_infos.each do |file_info|
        unless file_info == nil then
          puts file_info.hash.to_json
	      file_info.save
	    end
	  end
	end
	#file_infos
	0
  end
  
  def self.fileobject_to_hash object
    hash = {}
    ['filename','name_type','libmagic'].each do |elementName|
      if (object>elementName).length > 0 then
        hash.merge!({elementName => (object>elementName).text.strip})
      end
    end
    ['parent_object','partition','id','filesize','alloc','used','inode','meta_type','mode','nlink','uid','gid'].each do |elementName|
      if (object>elementName).length > 0 then
        hash.merge!({elementName => (object>elementName).text.strip.to_i})
      end
    end
    ['mtime','atime','crtime'].each do |elementName|
      if (object>elementName).length > 0 then
        hash.merge!({elementName => {'value' => (object>elementName).text.strip, 'prec' => ((object>elementName).attribute('prec').value.to_i)}})
      end
    end
    
    byte_runs = (object>'byte_runs>byte_run').map{|a| Hash[a.attributes.map{|b| [b[0] , b[1].value.to_i]}]}
    if byte_runs.length > 0 then    
      hash.merge!({'byte_runs' => byte_runs})
    end

    hashdigests = (object>'hashdigest').map{|a| Hash[a.attributes.map{|b| [b[0] , b[1].value]}].merge({'value' => a.text})}
    if hashdigests.length > 0 then    
      hash.merge!({'hashdigests' => hashdigests})
    end
    #puts hash.to_json
  end

  def self.modify_file_object hash
    name = hash['filename'].sub(/^.*\/([^\/]*)$/,'\1')
    hash['name'] = name
    
    hash['class'] = name.match(/^\.(\.)?$/) ? 'hide' : '';
    hash
  end
end
