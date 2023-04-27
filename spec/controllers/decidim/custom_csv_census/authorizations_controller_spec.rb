# frozen_string_literal: true

require "spec_helper"

module Decidim
  module CustomCsvCensus
    describe AuthorizationsController, type: :controller do
      routes { Decidim::CustomCsvCensus::Engine.routes }

      let(:user) { create(:user, :confirmed) }
      let(:organization) { user.organization }
      let(:authorization) { Authorization.last }
      let(:birth_date) { "01/02/2020".to_date }
      let(:params) do
        {
          authorization_handler: {
            id_document: "00000000Z",
            favourite_color: "pink",
            birth_date: birth_date,
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
            birth_date: birth_date,
            organization: organization
          )
        end

        it "creates an authorization" do
          post :create, params: params

          expect(flash[:notice]).not_to be_empty
          expect(response).to have_http_status(:redirect)
          expect(subject).to redirect_to(action: :index)
          expect(Decidim::Verifications::Authorizations.new(organization: organization).count).to be_positive
          expect(authorization.name).to eq("custom_csv_census_authorization_handler")
        end
      end
    end
  end
end
