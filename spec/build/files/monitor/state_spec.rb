# Copyright, 2012, by Samuel G. D. Williams. <http://www.codeotaku.com>
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

require 'build/files'
require 'build/files/monitor/state'

RSpec.describe Build::Files::Monitor::State do
	let(:files) {Build::Files::Glob.new(__dir__, "*.rb")}
	
	it "should have no changes initially" do
		state = Build::Files::Monitor::State.new(files)
		
		expect(state.update!).to be false
		
		expect(state.changed).to be == []
		expect(state.added).to be == []
		expect(state.removed).to be == []
		expect(state.missing).to be == []
	end
	
	it "should report missing files" do
		rebased_files = files.to_paths.rebase(File.join(__dir__, 'foo'))
		state = Build::Files::Monitor::State.new(rebased_files)
		
		# Some changes were detected:
		expect(state.update!).to be true
		
		# Some files are missing:
		expect(state.missing).to_not be_empty
	end
	
	it "should not be confused by duplicates" do
		state = Build::Files::Monitor::State.new(files + files)
		
		expect(state.update!).to be false
		
		expect(state.changed).to be == []
		expect(state.added).to be == []
		expect(state.removed).to be == []
		expect(state.missing).to be == []
	end
end

RSpec.describe Build::Files::Monitor::State do
	before(:each) do
		@temporary_files = Build::Files::Paths.directory(__dir__, ['a'])
		@temporary_files.touch
		
		@new_files = Build::Files::Monitor::State.new(@temporary_files)
		@old_files = Build::Files::Monitor::State.new(Build::Files::Glob.new(__dir__, "*.rb"))
	end
	
	after(:each) do
		@temporary_files.delete
	end
	
	let(:empty) {Build::Files::Monitor::State.new(Build::Files::List::NONE)}
	
	it "should be clean with empty inputs or outputs" do
		expect(Build::Files::Monitor::State.dirty?(empty, @new_files)).to be false
		expect(Build::Files::Monitor::State.dirty?(@new_files, empty)).to be false
	end
	
	it "should be clean if files are newer" do
		expect(Build::Files::Monitor::State.dirty?(@old_files, @new_files)).to be false
	end
	
	it "should be dirty if files are modified" do
		# In this case, the file mtime is usually different so... 
		expect(Build::Files::Monitor::State.dirty?(@new_files, @old_files)).to be true
	end
end
