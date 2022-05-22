# Copyright, 2014, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

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
