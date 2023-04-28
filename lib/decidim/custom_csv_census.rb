# frozen_string_literal: true

require "decidim/custom_csv_census/admin"
require "decidim/custom_csv_census/engine"
require "decidim/custom_csv_census/admin_engine"
require "decidim/custom_csv_census/workflow"

module Decidim
  # This namespace holds the logic of the `CustomCsvCensus` component. This component
  # allows users to create custom_csv_census in a participatory space.
  module CustomCsvCensus
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    class Configuration
      attr_accessor :col_sep, :fields

      def initialize
        @col_sep = ","
        @fields = {}
      end
    end

    autoload :CustomFields, "decidim/custom_csv_census/custom_fields"
  end
end
