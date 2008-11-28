#
# Buffer test - Ruvim
#

require 'test/unit'
require '../lib/ruvim/core'

class BufferTest < Test::Unit::TestCase

	def setup
		@buffer = Ruvim::Buffer.new(File.new('../test/buffer.data').read)
	end

	def test_movement
		assert_equal(0, @buffer.index)
		@buffer.forward 3
		assert_equal(3, @buffer.index)
		@buffer.forward 3
		assert_equal(6, @buffer.index)
		@buffer.back 4
		assert_equal(2, @buffer.index)
	end

	def test_line
		assert_equal(0, @buffer.line_start)
		assert_equal(6, @buffer.line_end)
		assert_equal("Line 1\n", @buffer.line)
		@buffer.forward 8
		assert_equal("Line 2\n", @buffer.line)
		@buffer.forward 8
		assert_equal("Line 3\n", @buffer.line)
		@buffer.forward 8
		assert_equal("Line 4\n", @buffer.line)
		@buffer.forward 8
		assert_equal("Line 5\n", @buffer.line)
	end

	def test_char
		assert_equal("L", @buffer.char)
		@buffer.forward 5
		assert_equal("1", @buffer.char)
	end

	def test_remove
		@buffer.remove
		assert_equal("ine 1\n", @buffer.line)
		@buffer.forward 5
		@buffer.remove
		assert_equal("ine 1Line 2\n", @buffer.line)
		@buffer.goto_eol.back.remove
		assert_equal("ine 1Line \n", @buffer.line)
		@buffer.forward 30
		size = @buffer.size
		@buffer.remove.remove
		assert_equal(size-2, @buffer.size)
		assert_equal(@buffer.size, @buffer.index)
		assert(@buffer.at_end?)
		assert_equal("Line ", @buffer.line)
	end

	def test_other
		assert_equal("Line 1\n", @buffer.to_eol)
		assert_equal("", @buffer.to_bol)
		@buffer.forward 7
		assert_equal("Line 2\n", @buffer.to_eol)
		assert_equal("", @buffer.to_bol)
		@buffer.forward 3
		assert_equal("Line 2\n", @buffer.to_bol + @buffer.to_eol)
		assert_equal("e 2\n", @buffer.to_eol)
		assert_equal("Lin", @buffer.to_bol)
	end

	def test_insert
		@buffer.insert("Hello")
		assert_equal("HelloLine 1\n", @buffer.line)
		@buffer.forward 6
		@buffer.insert "HAHAHA"
		assert(@buffer.at_eol?)
		assert_equal("HelloLine 1HAHAHA\n", @buffer.line)
	end
end
