# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'compliance/attestation'

describe Compliance::Attestation do
	let(:attestation) {Compliance::Attestation.new(id: "REQ-1", "by": "John Doe")}
	
	with "#as_json" do
		it "generates a JSON representation" do
			expect(attestation.as_json).to be == {id: "REQ-1", by: "John Doe"}
		end
		
		it "generates a JSON string" do
			expect(JSON.dump(attestation)).to be == attestation.to_json
		end
	end
end
