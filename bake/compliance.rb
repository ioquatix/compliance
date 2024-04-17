# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

def document
	document = Compliance::Document.new
	
	::Gem.loaded_specs.each do |name, spec|
		Console.logger.debug(self) {"Checking gem #{name}: #{spec.full_gem_path}..."}
		
		if path = spec.full_gem_path and File.directory?(path)
			Compliance::Loader.load(path, document)
		end
	end
	
	return document
end

def check(input:)
	policy = Compliance::Policy.new
	document = input || self.document
	
	unsatisfied = {}
	
	document.check(policy) do |requirement, satisfied, unsatisfied|
		Console.debug(self) {"Requirement #{requirement.id} is #{satisfied.any? ? "satisfied." : "not satisfied!"}"}
		
		if satisfied.empty?
			unsatisfied[requirement.id] = requirement
		end
	end
	
	raise Compliance::Error.new(unsatisfied) unless unsatisfied.empty?
end
