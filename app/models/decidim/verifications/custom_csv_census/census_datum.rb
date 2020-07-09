# frozen_string_literal: true

module Decidim
  module Verifications
    module CustomCsvCensus
      # Provides information about the current status of the census data
      class CensusDatum < ApplicationRecord
        # rubocop:disable Rails/InverseOf
        belongs_to :organization,
                   foreign_key: :decidim_organization_id,
                   class_name: "Decidim::Organization"
        # rubocop:enable Rails/InverseOf

        # An organzation scope
        def self.inside(organization)
          where(organization: organization)
        end

        # Search for a specific row inside the organization's census
        def self.search(organization, attributes)
          CensusDatum.inside(organization).find_by(
            attributes.transform_values { |v| encode(v) }
          )
        end

        # Encodes the values to conform with Decidim privacy guidelines.
        def self.encode(*values)
          Digest::SHA256.hexdigest(
            "#{values.join('-')}-#{Rails.application.secrets.secret_key_base}"
          )
        end

        # Clear all census data for a given organization
        def self.clear(organization)
          CensusDatum.inside(organization).delete_all
        end
      end
    end
  end
end
