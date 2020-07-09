# frozen_string_literal: true

module Decidim
  module Verifications
    module CustomCsvCensus
      # Decidim's Verifications Rails Admin Engine.
      class AdminEngine < ::Rails::Engine
        isolate_namespace Decidim::Verifications::CustomCsvCensus::Admin

        paths["db/migrate"] = nil
        paths["lib/tasks"] = nil


        routes do
          resources :custom_csv_census, only: %i[index create] do
            collection do
              delete :destroy
            end
          end

          root to: "custom_csv_census#index"
        end
      end
    end
  end
end
