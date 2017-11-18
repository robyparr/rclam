module Rclam
  module Helpers
    FRESHCLAM_REGEX = /^.+\/(\D{3} \D{3} \d{2} \d{2}:\d{2}:\d{2} \d{4})$/
    INFECTED_FILES_REGEX = /^Infected files: (\d+)$/
    SCANNED_FILES_REGEX = /^Scanned files: (\d+)$/
    TIME_REGEX = /^Time: .+\((\d \w{1} \d \w{1})\)$/
    SIGNATURES_REGEX = /^Known viruses: (\d+)$/

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

    def self.clamscan_report(results)
      infected_files = first_regex_capture(INFECTED_FILES_REGEX, results).to_i
      scanned_files = first_regex_capture(SCANNED_FILES_REGEX, results)
      signatures = first_regex_capture(SIGNATURES_REGEX, results)
      result = infected_files > 0 ? "!!INFECTED!!" : "CLEAN"

      result = %Q{
        Result:         #{result}
        Infections:     #{infected_files}
        Scanned Files:  #{scanned_files}
        Signatures:     #{signatures}
      }
      
      # Remove tabs from each line
      # https://stackoverflow.com/a/31345870
      result.each_line.map(&:strip).join("\n")
    end
  end
end