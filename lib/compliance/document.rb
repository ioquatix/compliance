# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'import'
require_relative 'requirement'
require_relative 'attestation'

module Compliance
	# Represents a document containing requirements and attestations.
	class Document
		def self.path(root)
			File.expand_path("compliance.json", root)
		end
		
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
			Hash.new.tap do |hash|
				if @imports.any?
					hash[:imports] = @imports.map(&:as_json)
				end
				
				if @requirements.any?
					hash[:requirements] = @requirements.map(&:as_json)
				end
				
				if @attestations.any?
					hash[:attestations] = @attestations.map(&:as_json)
				end
			end
		end
		
		def to_json(...)
			as_json.to_json(...)
		end
		
		attr :imports
		attr :requirements
		attr :attestations
	end
end
