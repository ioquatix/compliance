# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Compliance
	# Represents an error that occurs when requirements are not satisfied.
	class Error < StandardError
		def initialize(unsatisfied)
			super "Unsatisfied requirements: #{unsatisfied.keys.join(', ')}"
		end
	end
end
