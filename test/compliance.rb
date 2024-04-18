# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'compliance'

describe Compliance do
	it "should have a version number" do
		expect(Compliance::VERSION).to be =~ /\A\d+\.\d+\.\d+\z/
	end
	
	let(:loader) {Compliance::Loader.new}
	let(:compliance_path) {File.expand_path("compliance.json", __dir__)}
	
	it "can load document" do
		document = Compliance::Document.load(compliance_path)
		
		expect(document.imports.size).to be == 0
		expect(document.requirements.size).to be > 0
		expect(document.attestations.size).to be > 0
		
		policy = Compliance::Policy.new
		policy.add(document, loader)
		
		results = policy.check.to_h do |requirement, satisfied, unsatisfied|
			[requirement.id, satisfied.any?]
		end
		
		expect(results.size).to be > 0
		expect(results["PRJ-1"]).to be_truthy
		expect(results["PRJ-2"]).to be_falsey
	end
end
