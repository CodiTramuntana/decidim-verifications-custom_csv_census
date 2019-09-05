# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Verifications
    module CustomCsvCensus
      module Admin
        describe CreateCensusData do
          include_context "with tmp csv file"

          subject { described_class.call(form) }

          let!(:user) { create(:user) }
          let(:organization) { user.organization }
          let(:form) { CsvForm.from_params(params).with_context(context) }
          let(:params) { { file: file } }
          let(:file) { tmp_csv_file }
          let(:context) do
            {
              current_user: user,
              current_organization: organization
            }
          end
          let(:report) { CensusDataReport.last }

          context "when the form is not valid" do
            let(:file) { nil }

            it "broadcasts invalid" do
              expect { subject }.to broadcast(:invalid)
            end
          end

          context "whithout valid csv_data" do
            let(:row2) { "invalid" }
            let(:row3) { "invalid" }

            it "broadcasts invalid" do
              expect { subject }.to broadcast(:invalid)
            end
          end

          context "without new csv_data" do
            before do
              create(
                :census_datum,
                id_document: CensusDatum.encode("00000000Z"),
                organization: organization
              )
            end

            it "broadcasts ok" do
              expect { subject }.to broadcast(:ok)
            end

            it "does not create census data" do
              expect { subject }.not_to change(CensusDatum, :count)
            end

            it "does not create a report" do
              expect { subject }.not_to change(CensusDataReport, :count)
            end
          end

          context "when everything is ok" do
            it "broadcasts ok" do
              expect { subject }.to broadcast(:ok)
            end

            it "create census data" do
              expect { subject }.to change(CensusDatum, :count).by(1)
            end

            it "create a report" do
              expect { subject }.to change(CensusDataReport, :count).by(1)
              expect(report.num_inserts).to eq(1)
              expect(report.num_invalid).to eq(0)
            end

            it "traces the action", versioning: true do
              expect(Decidim.traceability)
                .to receive(:create!)
                .with(CensusDataReport, user, kind_of(Hash))
                .and_call_original

              expect { subject }.to change(Decidim::ActionLog, :count)
              action_log = Decidim::ActionLog.last
              expect(action_log.version).to be_present
            end
          end
        end
      end
    end
  end
end
