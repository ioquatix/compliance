require 'compliance'
require 'bake'

describe "bake/compliance.rb" do
	with "compliant project" do
		let(:context) {Bake::Context.load(File.expand_path(".fixtures/compliant-project", __dir__))}
		
		it "can load policy" do
			policy = context.lookup("compliance:policy").call
			
			expect(policy).to be_a(Compliance::Policy)
		end
		
		it "can check for issues" do
			results = context.lookup("compliance:check").call
			
			expect(results).to have_keys("REQ-1", "REQ-2")
		end
	end
	
	with "non-compliant project" do
		let(:context) {Bake::Context.load(File.expand_path(".fixtures/non-compliant-project", __dir__))}
	
		it "can check for issues" do
			expect do
				context.lookup("compliance:check").call
			end.to raise_exception(Compliance::Error, message: be =~ /REQ-2/)
		end
	end
	
	it "can attest to a requirement" do
		context = Bake::Context.load(File.expand_path(".fixtures/compliant-project", __dir__))
		
		context.lookup("compliance:attest").call("REQ-1")
		
		document = Compliance::Document.load(Compliance::Document.path(context.root))
		
		expect(document.attestations).to have_keys("REQ-1")
	end
end
