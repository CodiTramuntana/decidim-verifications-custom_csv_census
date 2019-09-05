# frozen_string_literal: true

module Decidim
  module Verifications
    module CustomCsvCensus
      # Provides information about the current status of the census data
      # for a given organization
      class Status
        include CustomFields

        def initialize(organization)
          @organization = organization
        end

        # Returns the date of the last import
        def last_import_at
          return nil unless records.any?

          @last_import_at ||= @records
                              .order(created_at: :desc)
                              .first
                              .created_at
        end

        # Returns the census data for a given organization
        def records
          @records ||= CensusDatum.inside(@organization)
        end

        # Returns the number of authorizations for a given organization census
        def authorizations_count
          @authorizations_count ||= Authorizations.new(
            organization: @organization,
            name: "custom_csv_census_authorization_handler"
          ).count
        end
      end
    end
  end
end
