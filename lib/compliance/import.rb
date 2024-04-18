# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Compliance
	# Represents an attestation of compliance with a requirement.
	class Import
		class Error < StandardError
		end
		
		def initialize(name)
			@name = name
		end
		
		def as_json(...)
			@name
		end
		
		def to_json(...)
			as_json.to_json(...)
		end
		
		attr :name
		
		def resolve(policy, loader)
			if document = loader.document_for(@name)
				policy.add(document, loader)
			else
				raise Error.new("Could not resolve import: #{@name}")
			end
		end
	end
end
