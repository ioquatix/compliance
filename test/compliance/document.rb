# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'compliance/document'
describe Compliance::Document do
	let(:imports) {[
		Compliance::Import.new("OWASP-ASVS-5.0"),
		Compliance::Import.new("PCI-DSS-3.2.1"),
	]}
	
	let(:requirements) {[
		Compliance::Requirement.new(id: "REQ-1", description: "This is a requirement."),
		Compliance::Requirement.new(id: "REQ-2", description: "This is another requirement."),
	]}
	
	let(:attestations) {[
		Compliance::Attestation.new(id: "REQ-1", by: "John Doe"),
	]}
	
	let(:document) {Compliance::Document.new(imports: imports, requirements: requirements, attestations: attestations)}
	
	with "#as_json" do
		it "generates a JSON representation" do
			expect(document.as_json).to be == {
				imports: imports.map(&:as_json),
				requirements: requirements.map(&:as_json),
				attestations: attestations.map(&:as_json)
			}
		end
		
		it "generates a JSON string" do
			expect(JSON.dump(document)).to be == document.to_json
		end
	end
end
