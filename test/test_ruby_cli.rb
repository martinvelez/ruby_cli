require 'test/unit'
require 'ruby_cli'

class RubyCLITest < Test::Unit::TestCase
  def test_hello_world
		m = Class.new do
			include RubyCLI	

			def command()	puts "Hello World" end
		end.new(ARGV)
		assert_equal(0, m.run)
  end
end
