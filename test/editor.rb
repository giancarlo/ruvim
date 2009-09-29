#
# Editor Class - Test Ruvim
#

require 'test/unit'
require 'ruvim/app'
require 'ruvim/editor'

Ruvim::Application.new

class TestEditor < Test::Unit::TestCase

	def setup
		@bufferdata = %{Line 1
Line 2
Line 3
Line 4
Line 5} 

		@editor = Ruvim::Editor.new($ruvim)
		@editor.buffer.load(@bufferdata)
	end

	def teardown
		Curses.close_screen
	end

	def test_correct_pos
#		assert(@editor.correct_pos(0) == [0,0])
	end

end
