# frozen_string_literal: true

require "spec_helper"

module Decidim
  module CustomCsvCensus
    module Admin
      describe DestroyCensusData do
        subject { described_class.new(user) }

        let(:user) { create(:user) }
        let(:organization) { user.organization }
        let(:report) { CensusDataReport.last }

        context "with nothing to destroy" do
          it "broadcasts ok" do
            expect { subject.call }.to broadcast(:ok)
          end

          it "does not create a report" do
            expect { subject.call }.not_to change(CensusDataReport, :count)
          end
        end

        context "when everything is ok" do
          before do
            create(:census_datum, organization: organization)
            create(:authorization, user: user, name: "custom_csv_census_authorization_handler")
          end

          it "broadcasts ok" do
            expect { subject.call }.to broadcast(:ok)
          end

          it "destroys census data" do
            expect { subject.call }.to change(CensusDatum, :count).by(-1)
          end

          it "destroys authorizations" do
            expect { subject.call }.to change(Authorization, :count).by(-1)
          end

          it "creates a report" do
            expect { subject.call }.to change(CensusDataReport, :count).by(1)
            expect(report.num_deleted).to eq(1)
            expect(report.num_revoked).to eq(1)
          end

          it "traces the action", versioning: true do
            expect(Decidim.traceability)
              .to receive(:perform_action!)
              .with(:delete, CensusDataReport, user)
              .and_call_original

            expect { subject.call }.to change(Decidim::ActionLog, :count)
            action_log = Decidim::ActionLog.last
            expect(action_log.version).to be_present
          end
        end
      end
    end
  end
end
