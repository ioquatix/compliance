# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

def initialize(...)
	super
	
	require 'compliance'
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

def all(description: nil, by: nil)
	compliance_root = Compliance::Document.path(context.root)
	
	if File.exist?(compliance_root)
		document = Compliance::Document.load(compliance_root)
	else
		document = Compliance::Document.new
	end
	
	policy = self.policy
	
	policy.requirements.each do |id, requirement|
		attestation = self.attestation_for(id, document)
		
		if description
			attestation.metadata[:description] = description
		end
		
		if by
			attestation.metadata[:by] = by
		end
	end
	
	File.write(compliance_root, JSON.pretty_generate(document))
end

private

# Load the default compliance policy.
def policy
	loader = Compliance::Loader.default([context.root])
	
	return Compliance::Policy.default(loader)
end

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
