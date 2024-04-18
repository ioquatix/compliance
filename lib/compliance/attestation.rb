# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Compliance
	# Represents an attestation of compliance with a requirement.
	class Attestation
		class Error < StandardError
		end
		
		def initialize(metadata)
			@metadata = metadata
		end
		
		def as_json(...)
			@metadata
		end
		
		def to_json(...)
			as_json.to_json(...)
		end
		
		# The unique identifier for this attestation.
		def id
			@metadata[:id]
		end
		
		# The metadata associated with this attestation.
		attr :metadata
		
		def [] key
			@metadata[key]
		end
	end
end
