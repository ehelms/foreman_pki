require "test_helper"

class ForemanPkiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ForemanPki::VERSION
  end
end
