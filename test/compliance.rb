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
	end
end
