# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021-2024, by Samuel Williams.

describe Build::Files::Monitor do
	it "has a version number" do
		expect(Build::Files::Monitor::VERSION).to be =~ /\d+\.\d+\.\d+/
	end
end

require 'build/files/monitor'
require 'build/files/path'
require 'build/files/system'
require 'build/files/directory'

AMonitor = Sus::Shared("a monitor") do
	let(:root) {Build::Files::Path.expand('tmp', File.expand_path(__dir__))}
	let(:path) {root + "test.txt"}
	
	def before
		super
		
		root.delete
		root.create
	end
	
	let(:directory) {Build::Files::Directory.new(root)}
	let(:monitor) {subject.new}
	
	it "should include touched path" do
		path.touch
		
		expect(directory.to_a).to be(:include?, path)
	end
	
	it 'should detect additions' do
		changed = false
		
		monitor.track_changes(directory) do |state|
			changed = true
			
			expect(state.added).to be(:include?, path)
		end
		
		thread = Thread.new do
			sleep 1
			path.touch
		end
		
		monitor.run do
			throw :interrupt if changed
		end
		
		thread.join
		
		expect(changed).to be == true
	end
	
	it "should add and remove monitored paths" do
		handler = monitor.track_changes(directory) do |state|
			# Do nothing.
		end
		
		expect(monitor.roots).to be(:include?, root)
		
		handler.remove!
		
		expect(monitor.roots).to be(:empty?)
	end
end

describe Build::Files::Monitor::Polling do
	it_behaves_like AMonitor
end

if defined? Build::Files::Monitor::Native
	describe Build::Files::Monitor::Native do
		it_behaves_like AMonitor
	end
end
