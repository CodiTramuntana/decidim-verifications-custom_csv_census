# frozen_string_literal: true

module Decidim
  module Verifications
    module CustomCsvCensus
      # Provides information about the current status of the census data
      class CensusDatum < ApplicationRecord
        include CustomFields

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
        #
        # Parameters:
        # organization  - The organization to which restrict the search
        # search_params - Hash with entries of the form field => search value.
        def self.search(organization, search_params)
          encode_flags= fields.slice(*search_params.keys).values.map {|options| options[:encoded]}
          CensusDatum.inside(organization).find_by(
            search_params.transform_values.with_index { |v, idx| encode_flags[idx] ? encode(v) : v }
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
