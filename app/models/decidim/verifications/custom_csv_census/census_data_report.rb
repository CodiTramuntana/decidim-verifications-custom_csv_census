# frozen_string_literal: true

module Decidim
  module Verifications
    module CustomCsvCensus
      # Provides information about the current status of the census data
      class CensusDataReport < ApplicationRecord
        include Decidim::Traceable

        # rubocop:disable Rails/InverseOf
        belongs_to :organization,
                   foreign_key: :decidim_organization_id,
                   class_name: "Decidim::Organization"
        # rubocop:enable Rails/InverseOf
        # rubocop:disable Rails/InverseOf
        belongs_to :user,
                   foreign_key: "decidim_user_id",
                   class_name: "Decidim::User"
        # rubocop:enable Rails/InverseOf

        # Sets the presenter class for the :admin_log for a RedirectRule resource.
        def self.log_presenter_class_for(_log)
          AdminLog::CensusDataReportPresenter
        end
      end
    end
  end
end
