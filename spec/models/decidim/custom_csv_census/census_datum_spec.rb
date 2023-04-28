# frozen_string_literal: true

require "spec_helper"

module Decidim
  module CustomCsvCensus
    describe CensusDatum, type: :model do
      let(:organization) { create(:organization) }
      let!(:data) do
        create(
          :census_datum,
          id_document: CensusDatum.encode("00000000Z"),
          organization: organization
        )
      end

      describe "::search" do
        subject { described_class.search(organization, attributes) }

        let(:attributes) { { id_document: "00000000Z" } }

        it { is_expected.to eq(data) }
      end
    end
  end
end
