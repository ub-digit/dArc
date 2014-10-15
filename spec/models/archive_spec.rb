require 'rails_helper'

RSpec.describe Archive, :type => :model do

	describe "find" do 
		context "with an existing id" do 
			it "returns a object" do 
				result = Archive.find(RSpec.configuration.db_ids[:archive])
				expect(result).to_not be nil
			end 
		end
		context "with a non existing id" do 
			it "raises an error" do 
				expect{Archive.find(-2)}.to raise_error
			end 
		end
	end

	describe "save" do
		context "with valid attributes" do
			it "should save without errors" do
				a = Archive.find(RSpec.configuration.db_ids[:archive], {:select => :update})
				a.from_json({"unitid" => "1337", "unitdate" => "1337 - 1408", "unittitle" => "A vewy vewy quiet archive"}.to_json)
				expect(a.save).to be true
			end
		end
		context "with an invalid title" do
			it "should return false" do
				a = Archive.find(RSpec.configuration.db_ids[:archive], {:select => :update})
				a.from_json({"title" => "", "unitid" => "1337", "unitdate" => "1337 - 1408", "unittitle" => "A vewy vewy quiet archive", "authorities" => a.as_json[:authorities]}.to_json)
				expect(a.save).to be false
				expect(a.errors.messages.size).to eq 1
			end
		end
		# context "with an empty authority list" do
		# 	it "should return false" do
		# 		a = Archive.find(RSpec.configuration.db_ids[:archive], {:select => :update})
		# 		a.from_json({"title" => "test title", "unitid" => "1337", "unitdate" => "1337 - 1408", "unittitle" => "A vewy vewy quiet archive", "authorities" => []}.to_json)
		# 		expect(a.save).to be false
		# 		expect(a.errors.messages.size).to eq 1
		# 	end
		# end
		context "adding an authority" do
			it "should save without errors" do
				a = Archive.find(RSpec.configuration.db_ids[:archive], {:select => :update})
				params = {"unitid" => "1338", "unitdate" => "1337 - 1408", "unittitle" => "A vewy vewy quiet archive", "authorities" => [RSpec.configuration.db_ids[:person], RSpec.configuration.db_ids[:person2]]}.to_json
				a.from_json(params)
				a.save

				# Check for updated relation through loop to allow for index to synchronize
				json = nil
				wait_for_relation(20.seconds) do
					b = Archive.find(RSpec.configuration.db_ids[:archive], {:select => :full})
					json = JSON.parse(b.to_json)
					json["authorities"].size > 1
				end
				expect(json["unitid"]).to eq "1338"
				expect(json["authorities"].size).to eq 2
			end
		end
		context "removing an authority" do 
			it "should save without errors" do
				a = Archive.find(RSpec.configuration.db_ids[:archive], {:select => :update})
				params = {"unitid" => "1339", "unitdate" => "1337 - 1408", "unittitle" => "A vewy vewy quiet archive", "authorities" => [RSpec.configuration.db_ids[:person]]}.to_json
				a.from_json(params)
				a.save

				# Check for updated relation through loop to allow for index to synchronize
				json = nil
				wait_for_relation(20.seconds) do
					b = Archive.find(RSpec.configuration.db_ids[:archive], {:select => :full})
					json = JSON.parse(b.to_json)
					json["authorities"].size < 2
				end
				expect(json["unitid"]).to eq "1339"
				expect(json["authorities"].size).to eq 1
			end
		end
	end
end