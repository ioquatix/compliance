# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Compliance
	# Represents a policy for checking compliance.
	class Policy
		def self.default(loader = Loader.default)
			self.new.tap do |policy|
				loader.documents.each do |document|
					policy.add(document, loader)
				end
			end
		end
		
		def initialize
			@requirements = {}
			@attestations = {}
		end
		
		attr :requirements
		attr :attestations
		
		def add(document, loader)
			document.requirements.each do |requirement|
				if @requirements.key?(requirement.id)
					raise Error.new("Duplicate requirement: #{requirement.id}")
				end
				
				@requirements[requirement.id] = requirement
			end
			
			document.attestations.each do |attestation|
				(@attestations[attestation.id] ||= Array.new) << attestation
			end
			
			document.imports.each do |import|
				import.resolve(self, loader)
			end
		end
		
		# Check the document against a given policy.
		def check
			return to_enum(:check) unless block_given?
			
			@requirements.each do |id, requirement|
				attestations = @attestations[id]
				
				satisfied = []
				unsatisfied = []
				
				attestations&.each do |attestation|
					if self.satisfies?(requirement, attestation)
						satisfied << attestation
					else
						unsatisfied << attestation
					end
				end
				
				yield requirement, satisfied, unsatisfied
			end
		end
		
		def satisfies?(requirement, attestation)
			requirement.id == attestation.id
		end
	end
end
