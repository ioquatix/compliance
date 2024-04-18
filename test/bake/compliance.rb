require 'compliance'
require 'bake'

describe "bake/compliance.rb" do
	with "compliant project" do
		let(:context) {Bake::Context.load(File.expand_path(".fixtures/compliant-project", __dir__))}
		
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
end
