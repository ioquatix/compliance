# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'compliance'

describe Compliance do
	it "should have a version number" do
		expect(Compliance::VERSION).to be =~ /\A\d+\.\d+\.\d+\z/
	end
	
	it "can load document" do
		document = Compliance::Document.new
		Compliance::Loader.load(__dir__, document)
		
		expect(document.requirements.size).to be > 0
		expect(document.attestations.size).to be > 0
		
		policy = Compliance::Policy.new
		results = document.check(policy).to_h do |requirement, satisfied, unsatisfied|
			[requirement.id, satisfied.any?]
		end
		
		expect(results.size).to be > 0
		expect(results["PRJ-1"]).to be_truthy
		expect(results["PRJ-2"]).to be_falsey
	end
end
