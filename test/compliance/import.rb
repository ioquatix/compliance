require 'compliance/import'

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
end
