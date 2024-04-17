# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Compliance
	class Policy
		def satisfies?(requirement, attestation)
			requirement.id == attestation.id
		end
	end
end
