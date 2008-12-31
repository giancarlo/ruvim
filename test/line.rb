#
# Line test - Ruvim
#

require 'test/unit'
require 'ruvim/core'

class BufferTest < Test::Unit::TestCase

	def setup
		@bufferdata = %{Line 1
Line 2
Line 3
Line 4
Line 5} 
		@buffer = Ruvim::Buffer.new(@bufferdata)
	end

	def test_to_s
		assert_equal("Line 1\n", @buffer.line.to_s)
		@buffer.forward 8
		assert_equal("Line 2\n", @buffer.line.to_s)
		@buffer.forward 8
		assert_equal("Line 3\n", @buffer.line.to_s)
		@buffer.forward 8
		assert_equal("Line 4\n", @buffer.line.to_s)
		@buffer.forward 8
		assert_equal("Line 5", @buffer.line.to_s)
	end

	def test_line
		assert_equal(0, @buffer.line.start)
		assert_equal(6, @buffer.line.end)
	end

end
