require "test_helper"
require "date"

class HelpersTest < Minitest::Test
  def test_first_regex_capture_returns_nil_if_nothing_found
    assert_nil nil, Rclam::Helpers.first_regex_capture(/\d/, 'a')
  end

  def text_first_regext_capture_returns_first_capture
    assert_equal 123, Rclam::Helpers.first_regex_capture(/(\d)/, 'a123')
  end

  def test_last_signatures_update_returns_date_time
    assert Rclam::Helpers.last_signatures_update.respond_to? :to_time
  end

  def test_date_within_a_day_is_correct
    assert Rclam::Helpers.date_within_a_day? DateTime.now
    refute Rclam::Helpers.date_within_a_day?(DateTime.now - 2)
  end
end
