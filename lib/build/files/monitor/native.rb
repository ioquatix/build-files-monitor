# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021-2024, by Samuel Williams.

require_relative 'polling'
require 'io/watch'

module Build
	module Files
		module Monitor
			class Native < Polling
				def run(**options, &block)
					catch(:interrupt) do
						while true
							run_roots(self.roots, **options, &block)
						end
					end
				end
				
				def run_roots(roots, **options, &block)
					monitor = IO::Watch::Monitor.new(self.roots, **options)
					
					monitor.run do |event|
						if root = event[:root]
							self.update([root])
							
							yield if block_given?
						
							if self.updated
								return true
							end
						end
					end
					
					return false
				end
			end
		end
	end
end
