require 'test_helper'

class ValuableTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Valuable::VERSION
  end
end
