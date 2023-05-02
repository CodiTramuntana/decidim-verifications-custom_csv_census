# frozen_string_literal: true

module Decidim
  module CustomCsvCensus
    module Admin
      # A command with the business logic to destroy census data for a
      # organization.
      class DestroyCensusData < Decidim::Command
        def initialize(current_user)
          @current_user = current_user
        end

        # Executes the command. Broadcast this events:
        # - :ok when everything is valid
        # - :invalid when the form wasn't valid and couldn't proceed-
        #
        # Returns nothing.
        def call
          destroy_census_data
          destroy_authorizations
          create_census_data_report

          broadcast(:ok)
        end

        private

        attr_reader :current_user

        delegate :organization, to: :current_user

        def destroy_census_data
          @census_data_count = CensusDatum.clear(organization)
        end

        def destroy_authorizations
          @authorizations_count = Decidim::Verifications::Authorizations.new(
            organization: organization,
            name: "custom_csv_census_authorization_handler"
          ).query.delete_all
        end

        def create_census_data_report
          return fake_report if (@census_data_count + @authorizations_count).zero?

          @report = Decidim.traceability.perform_action!(
            :delete,
            CensusDataReport,
            current_user
          ) do
            CensusDataReport.create!(
              organization: organization,
              user: current_user,
              num_deleted: @census_data_count,
              num_revoked: @authorizations_count
            )
          end
        end

        def fake_report
          @report = CensusDataReport.new(num_deleted: 0, num_revoked: 0)
        end
      end
    end
  end
end
