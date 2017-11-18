module Rclam
  module Helpers
    FRESHCLAM_REGEX = /^.+\/(\D{3} \D{3} \d{2} \d{2}:\d{2}:\d{2} \d{4})$/

    def self.first_regex_capture(regex, value)
      match = regex.match(value)
      return nil if match.nil?
      match.captures.first
    end

    def self.last_signatures_update
      version_header = %x{freshclam --version}
      regex = FRESHCLAM_REGEX.match(version_header)
      
      return nil if regex.nil?
      DateTime.parse regex.captures.first
    end

    def self.date_within_a_day?(date)
      hours_difference = ((DateTime.now.to_time - date.to_time) / 3600).to_i
      hours_difference <= 24
    end
  end
end