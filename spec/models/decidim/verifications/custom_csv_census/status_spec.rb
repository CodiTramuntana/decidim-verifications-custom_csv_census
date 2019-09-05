# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Verifications
    module CustomCsvCensus
      describe Status, type: :model do
        let(:user) { create(:user) }
        let(:organization) { user.organization }

        describe "#last_import_at" do
          subject { described_class.new(organization).last_import_at }

          context "with data" do
            let!(:data) { create(:census_datum, organization: organization) }

            it "returns last import date" do
              expect(subject.to_i).to eq(data.created_at.to_i)
            end
          end

          context "without data" do
            it { is_expected.to be_nil }
          end
        end

        describe "#authorizations_count" do
          subject { described_class.new(organization).authorizations_count }

          context "with authorizations" do
            before do
              create(:authorization, user: user, name: "custom_csv_census_authorization_handler")
              create(:authorization, user: user, name: "dummy_authorization_handler")
            end

            it { is_expected.to eq(1) }
          end

          context "without authorizations" do
            it { is_expected.to be_zero }
          end
        end
      end
    end
  end
end
