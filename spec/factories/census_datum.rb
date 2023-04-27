# frozen_string_literal: true

FactoryBot.define do
  factory :census_datum, class: "Decidim::CustomCsvCensus::CensusDatum" do
    organization
  end
end
