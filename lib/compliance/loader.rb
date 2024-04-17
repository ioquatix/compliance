# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'requirement'
require_relative 'attestation'

require 'json'

module Compliance
	# Load compliance data from JSON files.
	module Loader
		def self.add(compliance, document)
			compliance[:requirements]&.each do |metadata|
				document.add_requirement(Requirement.new(metadata))
			end
			
			compliance[:attestations]&.each do |metadata|
				document.add_attestation(Attestation.new(metadata))
			end
		end
		
		# Load compliance data from a directory.
		# @parameter root [String] The root directory to load compliance data from.
		# @parameter document [Document] The document to load compliance data into.
		def self.load(root, document)
			compliance_json_path = File.expand_path("compliance.json", root)
			
			if File.file?(compliance_json_path)
				data = JSON.load_file(compliance_json_path, symbolize_names: true)
				self.add(data, document)
			end
			
			compliance_directory = File.expand_path("compliance", root)
			
			if File.directory?(compliance_directory)
				Dir.glob(File.join(compliance_directory, "*.json")) do |path|
					data = JSON.load_file(path, symbolize_names: true)
					self.add(data, document)
				end
			end
		end
	end
end
