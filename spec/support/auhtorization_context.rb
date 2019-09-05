# frozen_string_literal: true

shared_context "with authorization workflow" do
  Decidim::Verifications.register_workflow(:custom_csv_census_authorization_handler) do |workflow|
    workflow.engine = Decidim::Verifications::CustomCsvCensus::Engine
    workflow.admin_engine = Decidim::Verifications::CustomCsvCensus::AdminEngine
  end
end
