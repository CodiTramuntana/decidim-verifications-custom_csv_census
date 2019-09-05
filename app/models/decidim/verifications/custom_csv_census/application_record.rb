# frozen_string_literal: true

module Decidim
  module Verifications
    module CustomCsvCensus
      class ApplicationRecord < ActiveRecord::Base
        self.abstract_class = true
      end
    end
  end
end
