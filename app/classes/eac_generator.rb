require 'nokogiri'

#Class for generating EAC from JSON, and convert EAC to JSON
class EacGenerator

	# Map translating type attribute to corresponding EAC-prefix
	def self.type_map
		{
			"person" => "pers",
			"corporatebody" => "corp",
			"family" => "fam"
		}
	end

	# generates an empty EAC document of a specified type. some mandatory structure is present
	def self.generate_empty(type)
		builder = Nokogiri::XML::Builder.new do |xml|
			xml.eac('type' => type, 'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance', 'xsi:schemaLocation' => 'http://xml.ra.se/EAC/RA_EAC.xsd', 'xmlns' => 'http://xml.ra.se/EAC') {
				xml.eacheader(status: "draft") {
					xml.eacid(countrycode: "SE", ownercode: Rails.application.config.ownercode){
						xml.text('')
					}
					xml.mainhist {
						xml.mainevent(maintype: "create") {
							xml.maindate Date.today.strftime('%F')
						}
					}
				}
				xml.condesc {
					xml.identity {
						xml.send(type_map[type]+"head", authorized: Rails.application.config.ownercode) {
							xml.part(type: "forename"){
								xml.text('')
							}
							xml.part(type: "surname"){
								xml.text('')
							}
						}
					}
				}
			}
		end

		builder.doc
	end

end