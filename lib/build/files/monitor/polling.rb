# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021-2024, by Samuel Williams.

require 'set'
require 'logger'

require_relative 'handle'

module Build
	module Files
		module Monitor
			class Polling
				def initialize(logger: nil)
					@directories = Hash.new do |hash, key|
						hash[key] = Set.new
					end
					
					@updated = false
					
					@deletions = nil
					
					@logger = logger || Logger.new(nil)
				end
				
				attr :updated
				
				# Notify the monitor that files in these directories have changed.
				def update(directories, *args)
					@logger.debug{"Update: #{directories} #{args.inspect}"}
					
					delay_deletions do
						directories.each do |directory|
							@logger.debug{"Directory: #{directory}"}
							
							@directories[directory].each do |handle|
								@logger.debug{"Handle changed: #{handle.inspect}"}
								
								# Changes here may not actually require an update to the handle:
								handle.changed!(*args)
							end
						end
					end
				end
				
				def roots
					@directories.keys
				end
				
				def delete(handle)
					if @deletions
						@logger.debug{"Delayed delete handle: #{handle}"}
						@deletions << handle
					else
						purge(handle)
					end
				end
				
				def track_changes(files, &block)
					handle = Handle.new(self, files, &block)
					
					add(handle)
				end
				
				def add(handle)
					@logger.debug{"Adding handle: #{handle}"}
					
					handle.directories.each do |directory|
						# We want the full path as a plain string:
						directory = directory.to_s
						
						@directories[directory] << handle
						
						# We just added the first handle:
						if @directories[directory].size == 1
							# If the handle already existed, this might trigger unnecessarily.
							@updated = true
						end
					end
					
					handle
				end
				
				def run(**options, &block)
					latency = options.fetch(:latency, 1.0)
					
					catch(:interrupt) do
						while true
							self.update(self.roots)
							
							yield if block_given?
							
							sleep(latency)
						end
					end
				end
				
				protected
				
				def delay_deletions
					@deletions = []
					
					yield
					
					@deletions.each do |handle|
						purge(handle)
					end
					
					@deletions = nil
				end
				
				def purge(handle)
					@logger.debug{"Purge handle: #{handle}"}
					
					handle.directories.each do |directory|
						directory = directory.to_s
						
						@directories[directory].delete(handle)
						
						# Remove the entire record if there are no handles:
						if @directories[directory].size == 0
							@directories.delete(directory)
							
							@updated = true
						end
					end
				end
			end
		end
	end
end
