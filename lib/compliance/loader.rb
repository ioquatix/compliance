# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'requirement'
require_relative 'attestation'

require 'json'

module Compliance
	# Load compliance data from JSON files.
	class Loader
		class Error < StandardError
		end
		
		# Setup the default loader.
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
			
			roots.uniq!
			
			self.new(roots)
		end
		
		def initialize(roots = [])
			@roots = roots
			@cache = nil
		end
		
		# List of root directories to search for compliance documents.
		attr :roots
		
		# Cache of name to path mappings.
		def cache
			@cache ||= build_cache
		end
		
		# Map a name to a path.
		def resolve(name)
			cache[name]
		end
		
		# Import a named document into the policy.
		def import(name, policy)
			if path = cache[name]
				begin
					document = Document.load(path)
				rescue => error
					raise Error, "Error loading compliance document: #{path}!"
				end
				
				begin
					policy.add(document, self)
				rescue => error
					raise Error, "Error adding compliance document to policy: #{path}!"
				end
			else
				raise Error, "Could not find import: #{name}"
			end
		end
		
		# Load all top level documents.
		def documents
			@roots.filter_map do |path|
				compliance_path = File.expand_path("compliance.json", path)
				if File.file?(compliance_path)
					begin
						Document.load(compliance_path)
					rescue => error
						raise Error, "Error loading compliance document: #{compliance_path}!"
					end
				end
			end
		end
		
		protected
		
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
