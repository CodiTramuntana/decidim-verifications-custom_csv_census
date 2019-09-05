# frozen_string_literal: true

module Decidim
  module Verifications
    module CustomCsvCensus
      class AuthorizationsController < Decidim::Verifications::AuthorizationsController
        private

        def handler
          @handler ||= CustomCsvCensusAuthorizationHandler.from_params(handler_params)
        end
      end
    end
  end
end
