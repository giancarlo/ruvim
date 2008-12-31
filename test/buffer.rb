#
# Buffer test - Ruvim
#

require 'test/unit'
require 'ruvim/buffer'

class BufferTest < Test::Unit::TestCase

	def setup
		@bufferdata = %{Line 1
Line 2
Line 3
Line 4
Line 5} 
		@buffer = Ruvim::Buffer.new(@bufferdata)
	end

	def test_at
		assert(@buffer.at_start?)
		assert(@buffer.at_bol?)
		@buffer.goto_eol
		assert(@buffer.at_eol?)
		@buffer.goto_end
		assert(@buffer.at_end?)
		assert(@buffer.at_eol?)
	end

	def test_movement
		assert_equal(0, @buffer.index)
		@buffer.forward 3
		assert_equal(3, @buffer.index)
		@buffer.forward 3
		assert_equal(6, @buffer.index)
		@buffer.back 4
		assert_equal(2, @buffer.index)
		@buffer.reset
		assert_equal(0, @buffer.index)
		assert(@buffer.at_start?)
		@buffer.goto(5)
		assert_equal(5, @buffer.index)
		@buffer.goto_eol
		assert(@buffer.at_eol?)
		@buffer.forward
		assert_equal("Line 2", @buffer.line.to_str)
		assert(@buffer.at_bol?)
		@buffer.goto_bol
		assert(@buffer.at_bol?)
		@buffer.goto_end
		assert(@buffer.at_end?)
	end
	
	def test_char
		assert_equal("L", @buffer.char)
		@buffer.forward 5
		assert_equal("1", @buffer.char)
	end

	def test_remove
		@buffer.remove
		assert_equal("ine 1\n", @buffer.line.to_s)
		@buffer.forward 5
		@buffer.remove
		assert_equal("ine 1Line 2\n", @buffer.line.to_s)
		@buffer.goto_eol.back.remove
		assert_equal("ine 1Line \n", @buffer.line.to_s)
		@buffer.forward 12

		size = @buffer.size
		@buffer.remove.remove
		assert_equal("Line", @buffer.line.to_str)
		assert_equal(size-2, @buffer.size)

		assert_equal("Line", @buffer.line.to_str)
	end

	def test_to
		assert_equal("Line 1\n", @buffer.to_eol)
		assert_equal("", @buffer.to_bol)
		@buffer.forward 7
		assert_equal("Line 2\n", @buffer.to_eol)
		assert_equal("", @buffer.to_bol)
		@buffer.forward 3
		assert_equal("Line 2\n", @buffer.to_bol + @buffer.to_eol)
		assert_equal("e 2\n", @buffer.to_eol)
		assert_equal("Lin", @buffer.to_bol)
		assert_equal("Line 1\nLin", @buffer.to_start)
		assert_equal("e 2\nLine 3\nLine 4\nLine 5", @buffer.to_end)
	end

	def test_insert
		@buffer.insert("Hello")
		assert_equal("HelloLine 1\n", @buffer.line.to_s)
		@buffer.forward 6
		@buffer.insert "HAHAHA"
		assert(6, @buffer.index)
		assert_equal("HelloLHAHAHAine 1", @buffer.line.to_str)
	end
end
