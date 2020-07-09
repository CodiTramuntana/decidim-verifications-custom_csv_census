# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Verifications
    module CustomCsvCensus
      describe CustomCsvCensusAuthorizationHandler do
        subject { described_class.from_params(params) }

        let(:params) { { id_document: id_document, favourite_color: "pink", birth_date: birth_date, user: user } }
        let(:id_document) { "00000000Z" }
        let(:birth_date) { "01/02/2020".to_date }
        let(:user) { create(:user) }
        let(:organization) { user.organization }

        let!(:data) do
          create(
            :census_datum,
            id_document: CensusDatum.encode(id_document),
            favourite_color: "purple",
            birth_date: birth_date,
            organization: organization
          )
        end

        it { is_expected.to be_valid }

        context "with missing fields" do
          let(:id_document) { nil }

          it { is_expected.to be_invalid }
        end

        context "with wrongly formatted fields" do
          let(:id_document) { "00000000z" }

          it { is_expected.to be_invalid }
        end
      end
    end
  end
end
