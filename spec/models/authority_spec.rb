require 'rails_helper'

RSpec.describe Authority, :type => :model do
	before :each do
		config_init
		@validAuthorityId = 25
	end

	describe "find" do 
		context "with an existing id" do 
			it "returns a object" do 
				result = Authority.find(@validAuthorityId)
				expect(result).to_not be nil
			end 
		end
		context "with a non existing id" do 
			it "raises an error" do 
				expect{Authority.find(-7)}.to raise_error
			end 
		end
		# context "with wrong object type" do
		# 	it "raises an error" do
		# 		expect{Authority.find(21)}.to raise_error
		# 	end
		# end
	end

	describe "class" do
		context "full_load" do
			it "should exist" do
				a = Authority.find(@validAuthorityId)
				expect(a.respond_to?(:full_load)).to be true
			end
		end
	end
end
