require 'nokogiri'

#Class for generating EAC from JSON, and convert EAC to JSON
class EacGenerator
	XML_SCHEMA = Pathname.new(Rails.root.to_s + "/app/assets/schemas/RA_EAC.xsd")
	#XMK_SCHEMA = "http://eac.staatsbibliothek-berlin.de/schema/cpf.xsd"

	# Map translating type attribute to corresponding EAC-prefix
	def self.type_map
		{
			"person" => "pers",
			"corporatebody" => "corp",
			"family" => "fam"
		}
	end

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

	# generates a valid EAC document from JSON source
	def self.generate_from_json(json, eventtype="create")
		data = JSON.parse(json)

		builder = Nokogiri::XML::Builder.new do |xml|
			xml.eac('type' => data["type"], 'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance', 'xsi:schemaLocation' => 'http://xml.ra.se/EAC/RA_EAC.xsd', 'xmlns' => 'http://xml.ra.se/EAC') {
				xml.eacheader(status: "draft") {
					xml.eacid(countrycode: "SE", ownercode: Rails.application.config.ownercode){
						xml.text(data["id"])
					}
					xml.mainhist {
						xml.mainevent(maintype: eventtype) {
							xml.maindate Date.today.strftime('%F')
						}
					}
				}
				xml.condesc {
					xml.identity {
						xml.send(type_map[data["type"]]+"head", authorized: Rails.application.config.ownercode) {
							xml.part(type: "forename"){
								xml.text(data["firstname"])
							}
							xml.part(type: "surname"){
								xml.text(data["surname"])
							}
						}
					}
					xml.desc{
						xml.send(type_map[data["type"]]+"desc") {
							xml.existdesc {
								xml.existdate(scope: "begin") {
									xml.text(data["startdate"])
								}
								xml.existdate(scope: "end") {
									xml.text(data["enddate"])
								}
							}
						}
						xml.bioghist {
							xml.p data["biography"]
						}
						
					}
					xml.funactrels {
						xml.funactrel {
							xml.funact "Snickare"
						}
					}
				}
			}
		end
		xml = builder.to_xml
		return schema_validation(xml)
	end

end