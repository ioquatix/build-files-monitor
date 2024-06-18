# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021-2024, by Samuel Williams.

module Build
	module Files
		module Monitor
			case RUBY_PLATFORM
			when /linux/i
				require_relative 'monitor/inotify'
				Native = INotify
				Default = Native
			when /darwin/i
				require_relative 'monitor/fsevent'
				Native = FSEvent
				Default = Native
			else 
				require_relative 'monitor/polling'
				Default = Polling
			end
		
			def self.new(*arguments, **options)
				Default.new(*arguments, **options)
			end
		end
	end
end
