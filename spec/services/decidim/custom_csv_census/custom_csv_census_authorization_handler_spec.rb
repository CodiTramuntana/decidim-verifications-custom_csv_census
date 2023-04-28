# frozen_string_literal: true

require "spec_helper"

module Decidim
  module CustomCsvCensus
    describe CustomCsvCensusAuthorizationHandler do
      subject { described_class.from_params(params) }

      let(:params) { { id_document: id_document, favourite_color: "pink", birth_date: birth_date, user: user } }
      let(:id_document) { "00000000Z" }
      let(:birth_date) { "01/02/2020".to_date }
      let(:user) { create(:user) }
      let(:organization) { user.organization }
      let(:search_attributes) { { id_document: id_document, birth_date: birth_date } }

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

      describe "#unique_id" do
        it "consists of all searchable fields hashed" do
          expect(subject.unique_id).to eq(CensusDatum.encode(search_attributes))
        end
      end

      describe "#metadata" do
        it "consists of all non encoded fields" do
          expect(subject.metadata).to eq({
                                           favourite_color: "pink",
                                           birth_date: birth_date.to_s
                                         })
        end
      end

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
