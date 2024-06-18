# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021-2024, by Samuel Williams.

require_relative 'polling'

require 'rb-fsevent'

module Build
	module Files
		module Monitor
			class FSEvent < Polling
				def run(**options, &block)
					notifier = ::FSEvent.new
					
					catch(:interrupt) do
						while true
							notifier.watch(self.roots) do |directories|
								directories.collect! do |directory|
									File.expand_path(directory)
								end
								
								self.update(directories)
								
								yield if block_given?
								
								if self.updated
									notifier.stop
								end
							end
							
							notifier.run
						end
					end
				end
			end
		end
	end
end
