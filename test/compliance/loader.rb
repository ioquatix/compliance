# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'compliance/loader'

describe Compliance::Loader do
	it "should have a default loader" do
		expect(Compliance::Loader.default).to be_a(Compliance::Loader)
	end
	
	it "can load requirements from a compliance library" do
		loader = Compliance::Loader.new([File.expand_path(".fixtures/library", __dir__)])
		document = Compliance::Document.load(loader.cache["requirements"])
		
		expect(document).to be_a(Compliance::Document)
		expect(document.requirements.size).to be == 2
	end
	
	it "can load requirements and attestations from a project" do
		loader = Compliance::Loader.new([
			File.expand_path(".fixtures/library", __dir__),
			File.expand_path(".fixtures/project", __dir__),
		])
		
		policy = Compliance::Policy.default(loader)
		
		expect(policy.requirements).to have_attributes(size: be == 2)
		expect(policy.attestations).to have_attributes(size: be == 1)
		
		results = policy.check.to_h do |requirement, satisfied, unsatisfied|
			[requirement.id, satisfied.any?]
		end
		
		expect(results).to have_keys(
			"REQ-1" => be_truthy,
			"REQ-2" => be_falsey,
		)
	end
end
