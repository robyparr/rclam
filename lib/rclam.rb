require "thor"
require "date"
require "open3"

require "rclam/version"
require "rclam/clamav"
require "rclam/helpers"

module Rclam
  class CLI < Thor
    desc "scan [location]", "Runs clamscan against the specified location."
    def scan(location = '/')
      not_installed         unless Rclam::ClamAV.installed?
      Rclam::ClamAV.update  unless Rclam::ClamAV.up_to_date?

      puts "Scanning #{File.expand_path(location)}..."
      result = Rclam::ClamAV.scan location
      puts Rclam::Helpers.clamscan_report(result)
    end

    private

      def not_installed
        puts "ClamAV is not installed. Please install before running."
        exit 1
      end
  end
end
