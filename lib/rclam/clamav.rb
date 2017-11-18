module Rclam
  module ClamAV

    def self.installed?
      executable_location = %x{which clamscan}
      !executable_location.empty?
    end

    def self.up_to_date?
      last_update = Rclam::Helpers.last_signatures_update
      Rclam::Helpers.date_within_a_day?(last_update)
    end

    def self.update
      %x{freshclam}
    end

    def self.scan(location)
      output, err, status = Open3.capture3("clamscan -ri #{location}")
      output
    end
  end
end