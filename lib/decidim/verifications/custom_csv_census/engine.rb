# frozen_string_literal: true

require "decidim/core"
require "decidim/verifications"

module Decidim
  module Verifications
    module CustomCsvCensus
      # Decidim's Verifications Rails Engine.
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Verifications::CustomCsvCensus

        routes do
          resources :authorizations, only: %i[new create index]

          root to: "authorizations#new"
        end
      end
    end
  end
end
