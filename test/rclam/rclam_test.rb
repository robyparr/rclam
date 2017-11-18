require "test_helper"

class RclamTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Rclam::VERSION
  end
end
