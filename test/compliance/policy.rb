require 'compliance/policy'
require 'compliance/requirement'

describe Compliance::Policy do
	it "merges matching requirements" do
		requirement1 = Compliance::Requirement.new(id: "REQ-1", a: 1)
		requirement2 = Compliance::Requirement.new(id: "REQ-1", b: 2)
		
		policy = Compliance::Policy.new
		
		policy.add_requirement(requirement1)
		policy.add_requirement(requirement2)
		
		expect(policy.requirements).to have_attributes(size: be == 1)
		expect(policy.requirements["REQ-1"].metadata).to have_keys(
			a: be == 1,
			b: be == 2
		)
	end
end
