require 'rails_helper'

RSpec.describe DarcFedora, :type => :model do

	describe "find" do 
		context "of wrong type" do 
			it "should raise an error" do 
				expect{DarcFedora.find(RSpec.configuration.db_ids[:authority])}.to raise_error
			end 
		end
		context "with a non existing id" do 
			it "should raise an error" do 
				expect{DarcFedora.find(-2)}.to raise_error
			end 
		end
		context "a valid integer id" do
			it "should return an object" do
				obj = Authority.find(RSpec.configuration.db_ids[:authority])
				expect(obj).to be_an Authority
			end
		end
		context "a valid string id" do
			it "should return an object" do
				obj = Authority.find("darc:" + RSpec.configuration.db_ids[:authority].to_s)
				expect(obj).to be_an Authority
			end
		end
	end

	describe "initialize" do
		context "a valid object" do
			it "should return an object" do
				authority = Person.find(RSpec.configuration.db_ids[:person])
				expect(authority).to_not be nil
				expect(authority).to be_a(Person)
			end
		end
		context "an object of the wrong type" do
			it "should raise an error" do
				string_id = Authority.numeric_id_to_fedora_id(RSpec.configuration.db_ids[:archive])
				obj = Authority.fedora_connection.find(string_id)
				expect{Authority.new(string_id, obj)}.to raise_error
			end
		end
	end

	describe "find_by_id" do
		context "with an existing value" do
			it "should return an object" do
				obj = Authority.find_by_id(RSpec.configuration.db_ids[:authority])
				expect(obj).to be_an(Authority)
			end
		end
		context "with a non existing value" do
			it "should return nil" do
				obj = Authority.find_by_id(-2)
				expect(obj).to be nil
			end
		end
	end

	describe "all" do
		context "of a valid model" do
			it "should return a list of objects" do
				list = Authority.all
				expect(list).to be_an(Array)
				expect(list.first).to be_an(Authority)
			end
		end
	end

	describe "create" do
		context "of a valid model" do
			it "should return an object" do
				obj = Authority.create
				@@create_id = obj.id
				expect(obj).to be_an(Authority)
			end
		end
	end

	describe "purge" do
		context "of a valid model" do
			it "should return a string" do
				res = Authority.purge(@@create_id.to_i)
				expect(res).to be true
			end
		end
	end

end
