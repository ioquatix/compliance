# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Compliance
	class Error < StandardError
		def initialize(unsatisfied)
			super "Unsatisfied requirements: #{unsatisfied.keys.join(', ')}"
		end
	end
end
