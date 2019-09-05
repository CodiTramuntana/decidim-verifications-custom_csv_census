# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Verifications
    module CustomCsvCensus
      describe AuthorizationsController, type: :controller do
        routes { Decidim::Verifications::CustomCsvCensus::Engine.routes }

        let(:user) { create(:user, :confirmed) }
        let(:organization) { user.organization }
        let(:authorization) { Authorization.last }
        let(:params) do
          {
            authorization_handler: {
              id_document: "00000000Z",
              user: user
            }
          }
        end

        before do
          allow(subject).to receive(:enforce_permission_to)
          controller.request.env["decidim.current_organization"] = organization
          sign_in user, scope: :user
        end

        describe "POST create" do
          before do
            create(
              :census_datum,
              id_document: CensusDatum.encode("00000000Z"),
              organization: organization
            )
          end

          it "creates an authorization" do
            post :create, params: params

            expect(flash[:notice]).not_to be_empty
            expect(response).to have_http_status(:redirect)
            expect(subject).to redirect_to(action: :index)
            expect(Authorizations.new(organization: organization).count).to be_positive
            expect(authorization.name).to eq("custom_csv_census_authorization_handler")
          end
        end
      end
    end
  end
end
