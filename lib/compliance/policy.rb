# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Compliance
	# Represents a policy for checking compliance.
	class Policy
		class Error < StandardError
		end
		
		# Load the policy from a given loader.
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
		
		def as_json(...)
			{
				requirements: @requirements,
				attestations: @attestations
			}
		end
		
		def to_json(...)
			as_json.to_json(...)
		end
		
		attr :requirements
		attr :attestations
		
		def add_requirement(requirement)
			if existing_requirement = @requirements[requirement.id]
				@requirements[requirement.id] = existing_requirement.merge(requirement)
			else
				@requirements[requirement.id] = requirement
			end
		end
		
		def add_attestation(attestation)
			(@attestations[attestation.id] ||= Array.new) << attestation
		end
		
		def add_import(import, loader)
			import.resolve(self, loader)
		end
		
		def add(document, loader)
			document.requirements.each do |requirement|
				add_requirement(requirement)
			end
			
			document.attestations.each do |attestation|
				add_attestation(attestation)
			end
			
			document.imports.each do |import|
				add_import(import, loader)
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
