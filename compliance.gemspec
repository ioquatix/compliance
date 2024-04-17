# frozen_string_literal: true

require_relative "lib/compliance/version"

Gem::Specification.new do |spec|
	spec.name = "compliance"
	spec.version = Compliance::VERSION
	
	spec.summary = "A framework for tracking compliance requirements and attestations."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.cert_chain  = ['release.cert']
	spec.signing_key = File.expand_path('~/.gem/release.pem')
	
	spec.homepage = "https://github.com/ioquatix/compliance"
	
	spec.metadata = {
		"documentation_uri" => "https://ioquatix.github.io/compliance/",
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
		"source_code_uri" => "https://github.com/ioquatix/compliance.git",
	}
	
	spec.files = Dir.glob(['{bake,lib}/**/*', '*.md'], File::FNM_DOTMATCH, base: __dir__)
	
	spec.required_ruby_version = ">= 3.1"
	
	spec.add_dependency "json"
end
