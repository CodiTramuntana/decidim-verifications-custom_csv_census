# frozen_string_literal: true

Decidim::Verifications.register_workflow(:custom_csv_census_authorization_handler) do |workflow|
  workflow.engine = Decidim::Verifications::CustomCsvCensus::Engine
  workflow.admin_engine = Decidim::Verifications::CustomCsvCensus::AdminEngine
end
