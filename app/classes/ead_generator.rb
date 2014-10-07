require 'nokogiri'

#Class for generating EAD from JSON, and convert EAD to JSON
class EadGenerator
	XML_SCHEMA = Pathname.new(Rails.root.to_s + "/app/assets/schemas/RA_EAD.xsd")
	#XMK_SCHEMA = "http://eac.staatsbibliothek-berlin.de/schema/cpf.xsd"


	# Validates xml against schema
	def self.schema_validation(xml)
		doc = Nokogiri::XML(xml)
		open(XML_SCHEMA.to_s) do |xsd_file|
			xsd = Nokogiri::XML::Schema(xsd_file.read)
			xsd.validate(doc).each do |error|
				puts error
				#errors.add(nil, "XML could not validate")
				return false
			end
		end
		return true
	end

	def self.generate_empty
		builder = Nokogiri::XML::Builder.new do |xml|
			xml.ead('xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance', 'xsi:schemaLocation' => 'http://xml.ra.se/EAD/RA_EAD.xsd', 'xmlns' => 'http://xml.ra.se/EAD'){
				xml.eadheader {
					xml.eadid(countrycode: "SE", mainagencycode: Rails.application.config.ownercode){
						xml.text('')
					}
					xml.filedesc {
						xml.titlestmt {
							xml.titleproper ''
							xml.author Rails.application.config.ownercode
						}
					}
					xml.revisiondesc {
						xml.change {
							xml.date Date.today.strftime('%F')
							xml.item "Created"
						}
					}
				}
			}
		end

		builder.doc
	end

end