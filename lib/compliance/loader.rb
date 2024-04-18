# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'requirement'
require_relative 'attestation'

require 'json'

module Compliance
	# Load compliance data from JSON files.
	class Loader
		def self.default(roots = [Dir.pwd])
			::Gem.loaded_specs.each do |name, spec|
				if path = spec.full_gem_path and File.directory?(path)
					compliance_path = File.expand_path("compliance.json", path)
					compliance_directory = File.expand_path("compliance", path)
					
					if File.file?(compliance_path) or File.directory?(compliance_directory)
						roots << path
					end
				end
			end
			
			self.new(roots)
		end
		
		def initialize(roots = [])
			@roots = roots
			@cache = nil
		end
		
		attr :roots
		
		def document_for(name)
			if path = cache[name]
				Document.load(path)
			end
		end
		
		def documents
			@roots.filter_map do |path|
				compliance_path = File.expand_path("compliance.json", path)
				if File.file?(compliance_path)
					Document.load(compliance_path)
				end
			end
		end
		
		protected
		
		def cache
			@cache ||= build_cache
		end
		
		def build_cache
			Hash.new.tap do |cache|
				@roots.each do |root|
					Dir.glob(File.expand_path("compliance/*.json", root)) do |path|
						name = File.basename(path, ".json")
						cache[name] = path
					end
				end
			end
		end
	end
end
