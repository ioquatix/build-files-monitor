# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021-2024, by Samuel Williams.

require_relative 'monitor/native'

module Build
	module Files
		module Monitor
			def self.new(*arguments, **options)
				Native.new(*arguments, **options)
			end
		end
	end
end
