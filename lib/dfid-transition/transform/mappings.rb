require 'dfid-transition/transform/document'

module DfidTransition
  module Transform
    ##
    # Given a set of output solutions with URIs and an attachment index,
    # #dump_csv will output a transition-compatible CSV to $stdout
    # (or `output_to`, if supplied)
    #
    class Mappings
      def initialize(attachment_index, solutions, output_to: $stdout)
        @attachment_index = attachment_index
        @solutions = solutions
        @output = output_to
      end

      HEADER_ROW = "Old URL, New URL\n".freeze

      def dump_csv
        @output.puts HEADER_ROW

        @solutions.each do |solution|
          doc = DfidTransition::Transform::Document.new(solution)

          @output.puts "#{doc.original_url},https://gov.uk/dfid-research-outputs/#{doc.original_id}\n"

          doc.downloads.each do |download|
            existing_details = @attachment_index.get(download.original_url.to_s)
            if existing_details
              @output.puts "#{download.original_url},#{existing_details['file_url']}\n"
            end
          end
        end
      end
    end
  end
end
