# frozen_string_literal: true

require "csv"

module Decidim
  module Verifications
    module CustomCsvCensus
      # Provides information about the current status of the census data
      class CsvData
        include CustomFields

        attr_reader :errors, :values

        def initialize(file, organization)
          @logger = Logger.new(Rails.root.join("log", "custom_csv_census.log"))
          @organization = organization
          @now = Time.current.to_s(:db)
          @filepath = file.path
          @filename = file.original_filename
          @errors = []
          @values = []
        end

        def columns
          headers + %i[decidim_organization_id created_at]
        end

        def read
          @logger.info "[#{self.class}] col_sep: '#{col_sep}'"
          return unless headers == fields.keys

          CSV.foreach(@filepath, options).with_index(1) { |row, i| process_row(row, i) }
        end

        private

        def headers
          @headers ||= CSV.open(@filepath, options, &:first).headers
        end

        def options
          {
            col_sep: col_sep,
            encoding: "UTF-8",
            headers: true,
            header_converters: :symbol,
            skip_blanks: true
          }
        end

        def process_row(row, line_number)
          processed_row = row.map do |key, value|
            value = process_value(key, value)
            value = CensusDatum.encode(value) if fields[key][:encoded]
            value
          end.push(@organization.id, @now)

          values << "('#{processed_row.join("','")}')"
        rescue StandardError => e
          @logger.error "[#{@organization.host}] '#{@filename}' - #{e.message} in line #{line_number}."
          errors << row
        end

        def process_value(key, value)
          if fields[key][:parse_first]
            value = parse(value, fields[key][:parse])
            value = validate(value, fields[key][:format])
          else
            value = validate(value, fields[key][:format])
            value = parse(value, fields[key][:parse])
          end
          value
        end

        def validate(value, regexp)
          return value unless regexp

          value.match?(regexp) ? value : raise("Format error")
        end

        def parse(value, procedure)
          return value unless procedure

          procedure.call(value)
        rescue StandardError
          raise("Parser error")
        end
      end
    end
  end
end
