# frozen_string_literal: true

module Decidim
  module Verifications
    module CustomCsvCensus
      module Admin
        class CustomCsvCensusController < Decidim::Admin::ApplicationController
          layout "decidim/admin/users"

          def index
            enforce_permission_to :index, :authorization
            @status = Status.new(current_organization)
          end

          def create
            enforce_permission_to :create, :authorization

            @form = form(CsvForm).from_params(params)

            CreateCensusData.call(@form) do
              on(:ok) do |report|
                flash[:notice] = t(".success", count: report.num_inserts, errors: report.num_invalid)
              end

              on(:invalid) do
                flash[:alert] = t(".error")
              end
            end

            redirect_to custom_csv_census_path
          end

          def destroy
            enforce_permission_to :destroy, :authorization

            DestroyCensusData.call(current_user) do
              on(:ok) do
                redirect_to custom_csv_census_path, notice: t(".success")
              end
            end
          end
        end
      end
    end
  end
end
