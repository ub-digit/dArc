require 'nokogiri'
require 'json'

class Dfxml
  def self.convert_to_json_sax filename,diskimageid,outdir
    start = Time.now
    
    parser = Nokogiri::XML::SAX::Parser.new(DfxmlDoc.new(outdir, diskimageid))
    parser.parse(File.open(filename))

	finish = Time.now
	diff = finish - start
	puts diff

	0
  end

class DfxmlDoc < Nokogiri::XML::SAX::Document

	def initialize outdir, diskimageid
		@outdir = outdir
		@diskimageid = diskimageid
	end


  def start_element name, attrs = []
	@current_chars = ""
    if name =='fileobject' then
	    @current_obj = {}
	    @in_obj = true
	elsif name =='volume' then
	    puts "starting: #{name}"
	    @current_volume = Hash[attrs]['offset'].to_i
	elsif @in_obj
		@current_field = name
	    @current_attrs = Hash[attrs]
	end
  end

  def end_element name
    if name == 'fileobject' then
       	@current_obj = Dfxml.modify_file_object @current_obj
       	@current_obj.merge!({'disk_image' => @diskimageid, 'volume' => @current_volume, 'identifier' => @current_volume.to_s + '_' + @current_obj['inode'].to_s, 'parent_identifier' => @current_volume.to_s + '_' + @current_obj['parent_object'].to_s })

          filename = @outdir + '/' + @current_obj['identifier']
          if(@current_obj['class'] == 'hide') then
            # skip
          elsif(File.exists? filename) then
            puts 'WARNING ' + @current_obj['inode'].to_s
          else
          	File.write(filename, @current_obj.to_json)
          end
	    #puts @current_obj
	    @in_obj = false
	elsif name == 'volume' then
	    puts "ending: #{name}"
	elsif @in_obj
		if ['filename','name_type','libmagic'].include? name then
			@current_obj.merge!({name => @current_chars.strip})
		elsif ['parent_object','partition','id','filesize','alloc','used','inode','meta_type','mode','nlink','uid','gid'].include? name then
			@current_obj.merge!({name => @current_chars.strip.to_i})
		elsif ['mtime','atime','crtime'].include? name then
	        @current_obj.merge!({name => {'value' => @current_chars.strip, 'prec' => @current_attrs['prec'].to_i}})
		elsif ['byte_run'].include? name then
			if !@current_obj['byte_runs'] then
				@current_obj['byte_runs'] = []
			end
	        @current_obj['byte_runs'].push @current_attrs
		elsif ['hashdigest'].include? name then
			if !@current_obj['hashdigests'] then
				@current_obj['hashdigests'] = []
			end
	        @current_obj['hashdigests'].push @current_attrs.merge({'value' => @current_chars.strip})
		elsif ['byte_runs'].include? name then
			# throw away
		else
			@current_obj.merge!({name => @current_chars})
        end
	end
  end

  def characters chars
	@current_chars += chars
  end
end

  def self.convert_to_json filename,diskimageid,outdir
    start = Time.now
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
          #puts ''
          #puts file_info.hash.to_json
          #puts file_info.hash['inode']
          filename = outdir + '/' + file_info.hash['inode'].to_s
          if(File.exists? filename) then
            puts 'WARNING ' + file_info.hash['inode'].to_s
          else
          	File.write(filename, file_info.hash.to_json)
          end
	      #file_info.save
	    end
	  end
	end
	finish = Time.now
	diff = finish - start
	puts diff
	#file_infos
	0
  end

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
