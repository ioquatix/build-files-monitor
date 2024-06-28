# frozen_string_literal: true

require_relative "lib/build/files/monitor/version"

Gem::Specification.new do |spec|
	spec.name = "build-files-monitor"
	spec.version = Build::Files::Monitor::VERSION
	
	spec.summary = "Efficiently monitor changes to the file system."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.cert_chain  = ['release.cert']
	spec.signing_key = File.expand_path('~/.gem/release.pem')
	
	spec.homepage = "https://github.com/ioquatix/build-files-monitor"
	
	spec.metadata = {
		"documentation_uri" => "https://ioquatix.github.io/build-files-monitor/",
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
		"source_code_uri" => "https://github.com/ioquatix/build-files-monitor.git",
	}
	
	spec.files = Dir.glob(['{lib}/**/*', '*.md'], File::FNM_DOTMATCH, base: __dir__)
	
	spec.required_ruby_version = ">= 3.1"
	
	spec.add_dependency "build-files", "~> 1.8"
	spec.add_dependency "io-watch", "~> 0.2"
end
