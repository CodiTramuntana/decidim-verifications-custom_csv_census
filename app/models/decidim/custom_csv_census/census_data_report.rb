# frozen_string_literal: true

module Decidim
  module CustomCsvCensus
    # Provides information about the current status of the census data
    class CensusDataReport < ApplicationRecord
      self.table_name = "decidim_verifications_custom_csv_census_census_data_reports"

      include Decidim::Traceable

      belongs_to :organization,
                 foreign_key: :decidim_organization_id,
                 class_name: "Decidim::Organization"
      belongs_to :user,
                 foreign_key: "decidim_user_id",
                 class_name: "Decidim::User"
      # Sets the presenter class for the :admin_log for a RedirectRule resource.
      def self.log_presenter_class_for(_log)
        AdminLog::CensusDataReportPresenter
      end
    end
  end
end
