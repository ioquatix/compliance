# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Compliance
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
		
		def id
			@metadata[:id]
		end
		
		attr :metadata
	end
end
