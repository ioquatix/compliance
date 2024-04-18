# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Compliance
	# Represents an error that occurs when requirements are not satisfied.
	class Error < StandardError
		def initialize(unsatisfied)
			super "#{unsatisfied.size} unsatisfied requirement(s): #{unsatisfied.keys.join(', ')}"
			
			@unsatisfied = unsatisfied
		end
		
		attr :unsatisfied
		
		def detailed_message(...)
			buffer = String.new
			buffer << super << "\n"
			
			@unsatisfied.map do |id, requirement|
				if description = requirement[:description]
					buffer << "\t- #{id}: #{description}" << "\n"
				end
			end
			
			buffer
		end
	end
end
