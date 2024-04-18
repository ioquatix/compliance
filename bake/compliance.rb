# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

def initialize(...)
	super
	
	require 'compliance'
end

# Load the default compliance policy.
def policy
	loader = Compliance::Loader.default([context.root])
	
	return Compliance::Policy.default(loader)
end

# List available compliance documents.
def list
	loader = Compliance::Loader.default([context.root])
	
	loader.cache.map do |name, path|
		{name: name, path: path}
	end
end

# Show a specific requirement and any associated attestations.
# @parameter id [String] The unique identifier for the requirement.
def show(id)
	policy = self.policy
	
	requirement = policy.requirements[id]
	
	if requirement
		$stdout.puts "Requirement: #{requirement.id}"
		$stdout.puts JSON.pretty_generate(requirement)
	end
	
	policy.attestations[id]&.each do |attestations|
		$stdout.puts "Attestation: #{attestation.id}"
		$stdout.puts JSON.pretty_generate(attestation)
	end
end

# Check compliance with the policy.
def check
	policy = self.policy

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
