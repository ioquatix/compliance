# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'requirement'
require_relative 'attestation'

module Compliance
	class Document
		def initialize
			@requirements = []
			@attestations = []
			
			@attestations_by_id = {}
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
			@requirements << requirement
		end
		
		# @parameter attestation [Attestation] The attestation to add to the document.
		def add_attestation(attestation)
			@attestations << attestation
			(@attestations_by_id[attestation.id] ||= Array.new) << attestation
		end
		
		def check(policy)
			return to_enum(:check, policy) unless block_given?
			
			@requirements.each do |requirement|
				attestations = @attestations_by_id[requirement.id]
				
				satisfied = []
				unsatisfied = []
				
				attestations&.each do |attestation|
					if policy.satisfies?(requirement, attestation)
						satisfied << attestation
					else
						unsatisfied << attestation
					end
				end
				
				yield requirement, satisfied, unsatisfied
			end
		end
	end
end
