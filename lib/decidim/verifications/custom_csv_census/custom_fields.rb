# frozen_string_literal: true

module Decidim
  module Verifications
    module CustomCsvCensus
      module CustomFields
        extend ActiveSupport::Concern

        module CustomFieldsMethods
          delegate :configuration, to: "Decidim::Verifications::CustomCsvCensus"
          delegate :col_sep, to: :configuration
          delegate :fields, to: :configuration

          def search_fields
            @search_fields ||= fields.select { |_k, v| v[:search] }
          end

          def search_keys
            search_fields.keys
          end
        end

        included do
          include CustomFieldsMethods
        end

        class_methods do
          include CustomFieldsMethods
        end
      end
    end
  end
end
