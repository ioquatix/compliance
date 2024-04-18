# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

def initialize(...)
	super
	
	require 'compliance'
end

def policy
	loader = Compliance::Loader.default([context.root])
	
	return Compliance::Policy.default(loader)
end

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

def attest(id)
	compliance_root = Compliance::Document.path(context.root)
	
	if File.exist?(compliance_root)
		document = Compliance::Document.load(compliance_root)
	else
		document = Compliance::Document.new
	end
	
	attestation = Compliance::Attestation.new(id: id)
	
	# Check if the attestation already exists:
	document.attestations.each do |existing_attestation|
		if existing_attestation.id == id
			raise Compliance::Attestation::Error.new("Attestation with id #{id} already exists!")
		end
	end
	
	document.attestations << attestation
	
	File.write(compliance_root, JSON.pretty_generate(document))
end
