# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021-2024, by Samuel Williams.

require_relative 'polling'

require 'rb-inotify'

module Build
	module Files
		module Monitor
			class INotify < Polling
				def run(**options, &block)
					notifier = ::INotify::Notifier.new
					
					catch(:interrupt) do
						while true
							self.roots.each do |root|
								notifier.watch root, :create, :modify, :attrib, :delete do |event|
									self.update([root])
									
									yield if block_given?
									
									if self.updated
										notifier.stop
									end
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
