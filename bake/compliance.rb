# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

def initialize(...)
	super
	
	require 'compliance'
end

def policy
	default_policy
end

def check
	policy = default_policy

	failed_requirements = {}
	
	results = policy.check do |requirement, satisfied, unsatisfied|
		Console.debug(self) {"Requirement #{requirement.id} is #{satisfied.any? ? "satisfied." : "not satisfied!"}"}
		
		if satisfied.empty?
			failed_requirements[requirement.id] = requirement
		end
	end
	
	if failed_requirements.any?
		raise Compliance::Error.new(failed_requirements)
	else
		Console.debug(self) {"All requirements are satisfied."}
		return results
	end
end

private

def default_policy
	loader = Compliance::Loader.default([context.root])
	Compliance::Policy.default(loader)
end
