class Dfxml

	def self.print filename, diskimageid
		DfxmlParser.parse_dfxml filename, default_modifiers(diskimageid), DfxmlFileobjectWriter::StdoutWriter.new
	end

	def self.write filename, diskimageid, outdir
		DfxmlParser.parse_dfxml filename,  default_modifiers(diskimageid), DfxmlFileobjectWriter::FileWriter.new(outdir)
	end

	def self.load filename, diskimageid
		DfxmlParser.parse_dfxml filename, default_modifiers(diskimageid), DfxmlFileobjectWriter::MongodbWriter.new
	end

	def self.config 
		DfxmlFileobjectCategorizer.read_config 'config/ingest_categorization.rb'
	end

	def self.default_modifiers diskimageid
		[DfxmlFileobjectModifier::DiskImageId.new(diskimageid),
		 DfxmlFileobjectModifier::Names.new,
		 DfxmlFileobjectCategorizer.new(config)]
	end
end
