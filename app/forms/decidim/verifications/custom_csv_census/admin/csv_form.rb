# frozen_string_literal: true

module Decidim
  module Verifications
    module CustomCsvCensus
      module Admin
        # A form to temporaly upload csv census data
        class CsvForm < Form
          mimic :csv

          attribute :file
          validates_presence_of :file
          validate :csv_must_be_readable, if: :file

          def csv_data
            @csv_data ||= CsvData.new(file, current_organization)
          end

          private

          def csv_must_be_readable
            csv_data.read
          rescue CSV::MalformedCSVError
            errors.add(:file, :invalid)
          end
        end
      end
    end
  end
end
