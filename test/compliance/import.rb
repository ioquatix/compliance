require 'compliance/import'
require 'compliance/loader'

describe Compliance::Import do
	let(:import) {Compliance::Import.new("OWASP-ASVS-5.0")}
	
	with "#as_json" do
		it "generates a JSON representation" do
			expect(import.as_json).to be == "OWASP-ASVS-5.0"
		end
		
		it "generates a JSON string" do
			expect(JSON.dump(import)).to be == import.to_json
		end
	end
	
	it "fails to load non-existent document" do
		loader = Compliance::Loader.new
		policy = Compliance::Policy.new
		
		expect do
			import.resolve(policy, loader)
		end.to raise_exception(Compliance::Import::Error, message: be =~ /Could not resolve/)
	end
end
