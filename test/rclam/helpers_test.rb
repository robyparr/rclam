require "test_helper"
require "date"

class HelpersTest < Minitest::Test
  SCAN_RESULTS_CLEAN = %q{
    ----------- SCAN SUMMARY -----------
    Known viruses: 6344366
    Engine version: 0.99.2
    Scanned directories: 1
    Scanned files: 8
    Infected files: 0
    Data scanned: 0.00 MB
    Data read: 0.00 MB (ratio 0.00:1)
    Time: 7.390 sec (0 m 7 s)
  }.each_line.map(&:strip).join("\n")

  SCAN_RESULTS_INFECTED = %q{
    ----------- SCAN SUMMARY -----------
    Known viruses: 6344366
    Engine version: 0.99.2
    Scanned directories: 1
    Scanned files: 8
    Infected files: 1
    Data scanned: 0.00 MB
    Data read: 0.00 MB (ratio 0.00:1)
    Time: 7.390 sec (0 m 7 s)
  }.each_line.map(&:strip).join("\n")

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

  def test_scan_report_returns_clean_summary
    report = Rclam::Helpers.clamscan_report(SCAN_RESULTS_CLEAN)

    assert_match "Result:         CLEAN",   report
    assert_match "Infections:     0",       report
    assert_match "Scanned Files:  8",       report
    assert_match "Signatures:     6344366", report
  end

  def test_scan_report_returns_clean_summary
    report = Rclam::Helpers.clamscan_report(SCAN_RESULTS_INFECTED)

    assert_match "Result:         !!INFECTED!!",    report
    assert_match "Infections:     1",               report
    assert_match "Scanned Files:  8",               report
    assert_match "Signatures:     6344366",         report
  end
end
