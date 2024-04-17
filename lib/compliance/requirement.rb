# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Compliance
	# Represents a requirement that can be satisfied by an attestation.
	class Requirement
		def initialize(metadata)
			@metadata = metadata
		end
		
		def as_json(...)
			@metadata
		end
		
		def to_json(...)
			as_json.to_json(...)
		end
		
		# The unique identifier for this requirement.
		def id
			@metadata[:id]
		end
		
		# The metadata associated with this requirement.
		attr :metadata
	end
end
