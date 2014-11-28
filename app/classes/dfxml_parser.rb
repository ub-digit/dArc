require 'nokogiri'
require 'json'

class DfxmlParser

	def self.parse_dfxml filename, modifiers, writer
		start = Time.now

		parser = Nokogiri::XML::SAX::Parser.new(DfxmlDoc.new(modifiers, writer))
		parser.parse(File.open(filename))

		finish = Time.now
		diff = finish - start
	end

	class DfxmlDoc < Nokogiri::XML::SAX::Document

		def initialize modifiers, writer
			@modifiers = modifiers
			@writer = writer
		end

		def start_element name, attrs = []
			@current_chars = ""
			if name =='fileobject' then
				@current_obj = {}
				@in_obj = true
			elsif name =='volume' then
				@current_volume = Hash[attrs]['offset'].to_i
			elsif @in_obj
				@current_field = name
				@current_attrs = Hash[attrs]
			end
		end

		def end_element name
			if name == 'fileobject' then
				# add volume based identifiers
				@current_obj.merge!({	'volume' => @current_volume,
										'identifier' => @current_volume.to_s + '_' + @current_obj['inode'].to_s,
										'parent_identifier' => @current_volume.to_s + '_' + @current_obj['parent_object'].to_s })

				# run all the modifiers
				@modifiers.each { |modifier| modifier.modify!(@current_obj) }

				# write to the writer
				@writer.write(@current_obj)

				@in_obj = false
			elsif name == 'volume' then
				# throw away
			elsif @in_obj
				if ['filename','name_type','libmagic'].include? name then
					# string values
					@current_obj.merge!({name => @current_chars.strip})
				elsif ['parent_object','partition','id','filesize','alloc','used','inode','meta_type','mode','nlink','uid','gid'].include? name then
					# integer values
					@current_obj.merge!({name => @current_chars.strip.to_i})
				elsif ['mtime','atime','crtime'].include? name then
					# date values (with prec)
					@current_obj.merge!({name => {'value' => @current_chars.strip, 'prec' => @current_attrs['prec'].to_i}})
				elsif ['byte_run'].include? name then
					# repeating byte runs with values in attributes
					if !@current_obj['byte_runs'] then
						@current_obj['byte_runs'] = []
					end
					@current_obj['byte_runs'].push @current_attrs
				elsif ['hashdigest'].include? name then
					# repeating hashdigests with main value in body and other data as attributes (type)
					if !@current_obj['hashdigests'] then
						@current_obj['hashdigests'] = []
					end
					@current_obj['hashdigests'].push @current_attrs.merge({'value' => @current_chars.strip})
				elsif ['byte_runs'].include? name then
					# throw away
				else
					# treat unknown elements as strings
					@current_obj.merge!({name => @current_chars})
				end
			end
		end

		def characters chars
			@current_chars += chars
		end
	end
end
