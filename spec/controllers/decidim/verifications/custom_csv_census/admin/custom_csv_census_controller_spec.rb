# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Verifications
    module CustomCsvCensus
      module Admin
        describe CustomCsvCensusController, type: :controller do
          include_context "with tmp csv file"

          routes { Decidim::Verifications::CustomCsvCensus::AdminEngine.routes }

          let(:user) { create(:user, :confirmed, :admin) }
          let(:organization) { user.organization }
          let(:params) { { file: fixture_file_upload(tmp_csv_path) } }

          before do
            controller.request.env["decidim.current_organization"] = organization
            sign_in user, scope: :user
          end

          describe "GET index" do
            it "returns http success" do
              get :index

              expect(response).to have_http_status(:success)
              expect(subject).to render_template(:index)
            end
          end

          describe "POST create" do
            it "creates census data" do
              post :create, params: params

              expect(flash[:notice]).not_to be_empty
              expect(response).to have_http_status(:redirect)
              expect(subject).to redirect_to(action: :index)
              expect(CensusDatum.inside(organization).count).to be_positive
            end
          end

          describe "POST destroy" do
            before do
              create(:census_datum, organization: organization)
              create(:authorization, user: user, name: "custom_csv_census_authorization_handler")
            end

            it "destroys census data and authorizations" do
              delete :destroy

              expect(flash[:notice]).not_to be_empty
              expect(response).to have_http_status(:redirect)
              expect(subject).to redirect_to(action: :index)
              expect(CensusDatum.inside(organization).count).to be_zero
              expect(Authorizations.new(organization: organization).count).to be_zero
            end
          end
        end
      end
    end
  end
end
