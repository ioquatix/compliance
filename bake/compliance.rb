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

# Attest to a requirement.
# @parameter id [String] The unique identifier for the attestation, matching the requirement.
# @parameter description [String] A description of how the requirement is satisfied.
# @parameter by [String] The entity attesting to the requirement.
def attest(id, description: nil, by: nil)
	compliance_root = Compliance::Document.path(context.root)
	
	if File.exist?(compliance_root)
		document = Compliance::Document.load(compliance_root)
	else
		document = Compliance::Document.new
	end
	
	attestation = self.attestation_for(id, document)
	
	if description
		attestation.metadata[:description] = description
	end
	
	if by
		attestation.metadata[:by] = by
	end
	
	File.write(compliance_root, JSON.pretty_generate(document))
	
	return attestation
end

private

def attestation_for(id, document)
	document.attestations.each do |attestation|
		if attestation.id == id
			return attestation
		end
	end
	
	attestation = Compliance::Attestation.new(id: id)
	document.attestations << attestation
	
	return attestation
end
