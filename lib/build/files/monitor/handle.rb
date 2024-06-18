# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021-2024, by Samuel Williams.

require 'build/files/state'

module Build
	module Files
		module Monitor
			class Handle
				def initialize(monitor, files, &block)
					@monitor = monitor
					@state = State.new(files)
					@block = block
				end
			
				attr :monitor
			
				def commit!
					@state.update!
				end
			
				def directories
					@state.files.roots
				end
			
				def remove!
					@monitor.delete(self)
				end
				
				# Inform the handle that it might have been modified.
				def changed!
					# If @state.update! did not find any changes, don't invoke the callback:
					if @state.update!
						@block.call(@state)
					end
				end
				
				def to_s
					"\#<#{self.class} @state=#{@state} @block=#{@block}>"
				end
			end
		end
	end
end
