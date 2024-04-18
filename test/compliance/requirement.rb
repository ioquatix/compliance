# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'compliance/requirement'

describe Compliance::Requirement do
	let(:requirement) {Compliance::Requirement.new(id: "REQ-1", description: "This is a requirement.")}
	
	with "#as_json" do
		it "generates a JSON representation" do
			expect(requirement.as_json).to be == {id: "REQ-1", description: "This is a requirement."}
		end
		
		it "generates a JSON string" do
			expect(JSON.dump(requirement)).to be == requirement.to_json
		end
	end
end
