
require_relative "lib/build/files/monitor/version"

Gem::Specification.new do |spec|
	spec.name = "build-files-monitor"
	spec.version = Build::Files::Monitor::VERSION
	
	spec.summary = "Efficiently monitor changes to the file system."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.homepage = "https://github.com/ioquatix/build-files-monitor"
	
	spec.metadata = {
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
	}
	
	spec.files = Dir.glob('{lib}/**/*', File::FNM_DOTMATCH, base: __dir__)
	
	spec.required_ruby_version = ">= 2.4.0"
	
	spec.add_dependency "rb-fsevent"
	spec.add_dependency "rb-inotify"
	spec.add_dependency "build-files", "~> 1.7"
	
	spec.add_development_dependency "bundler"
	spec.add_development_dependency "covered"
	spec.add_development_dependency "rspec", "~> 3.4"
end
