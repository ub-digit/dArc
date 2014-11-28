class DfxmlFileobjectWriter
	def write object
	end

	# writes to stdout
	class DfxmlFileobjectWriter::StdoutWriter < DfxmlFileobjectWriter
		def write object
			puts object.to_json.to_s
		end
	end

	# writes to a file
	class DfxmlFileobjectWriter::FileWriter < DfxmlFileobjectWriter
		def initialize outdir
			@outdir = outdir
		end

		def write object
			filename = @outdir + '/' + object['identifier']
			if(object['class'] == 'hide') then
				# skip
			elsif(File.exists? filename) then
				puts 'WARNING ' + object['inode'].to_s
			else
				File.write(filename, object.to_json)
			end
		end
	end
	
	# writes to mongodb
	class DfxmlFileobjectWriter::MongodbWriter < DfxmlFileobjectWriter
		def write object
			ContentFileInfo.new(object).save
		end
	end
end
