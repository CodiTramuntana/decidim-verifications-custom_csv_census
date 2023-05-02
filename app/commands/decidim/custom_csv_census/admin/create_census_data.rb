# frozen_string_literal: true

module Decidim
  module CustomCsvCensus
    module Admin
      # A command with the business logic to create census data for a
      # organization.
      class CreateCensusData < Decidim::Command
        def initialize(form)
          @form = form
        end

        # Executes the command. Broadcast this events:
        # - :ok when everything is valid
        # - :invalid when the form wasn't valid and couldn't proceed-
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid? || csv_data.values.empty?

          create_census_data
          create_census_data_report

          broadcast(:ok, @report)
        end

        private

        attr_reader :form

        delegate :csv_data, to: :form

        def create_census_data
          @result = begin
            table_name = CensusDatum.table_name
            columns = csv_data.columns.join(",")
            values = csv_data.values.join(",")
            sql = "INSERT INTO #{table_name} (#{columns}) VALUES #{values} ON CONFLICT DO NOTHING;"
            ActiveRecord::Base.connection.execute(sql)
          end
        end

        def create_census_data_report
          return fake_report if @result.cmd_tuples.zero?

          @report = Decidim.traceability.create!(
            CensusDataReport,
            form.current_user,
            organization: form.current_organization,
            user: form.current_user,
            num_invalid: csv_data.errors.count,
            num_inserts: @result.cmd_tuples
          )
        end

        def fake_report
          @report = CensusDataReport.new(num_invalid: csv_data.errors.count, num_inserts: 0)
        end
      end
    end
  end
end
