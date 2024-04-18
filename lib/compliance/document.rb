# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'import'
require_relative 'requirement'
require_relative 'attestation'

module Compliance
	# Represents a document containing requirements and attestations.
	class Document
		def self.load(path)
			data = JSON.load_file(path, symbolize_names: true)
			
			self.new.tap do |document|
				data[:imports]&.each do |import|
					document.imports << Import.new(import)
				end
				
				data[:requirements]&.each do |metadata|
					document.requirements << Requirement.new(metadata)
				end
				
				data[:attestations]&.each do |metadata|
					document.attestations << Attestation.new(metadata)
				end
			end
		end
		
		def initialize(imports: [], requirements: [], attestations: [])
			@imports = imports
			@requirements = requirements
			@attestations = attestations
		end
		
		def as_json(...)
			{
				imports: @imports.map(&:as_json),
				requirements: @requirements.map(&:as_json),
				attestations: @attestations.map(&:as_json)
			}
		end
		
		def to_json(...)
			as_json.to_json(...)
		end
		
		attr :imports
		attr :requirements
		attr :attestations
	end
end
