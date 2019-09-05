# frozen_string_literal: true

class CreateDecidimVerificationsCustomCsvCensusCensusDataReports < ActiveRecord::Migration[5.1]
  def change
    create_table :decidim_verifications_custom_csv_census_census_data_reports do |t|
      t.references :decidim_organization, index: { name: "census_data_reports_org_id_index" }
      t.references :decidim_user, index: { name: "census_data_reports_user_id_index" }
      t.integer :num_invalid, default: 0
      t.integer :num_inserts, default: 0
      t.integer :num_deleted, default: 0
      t.integer :num_revoked, default: 0

      # The rows in this table are immutable (insert or delete, not update)
      # To explicitly reflect this fact there is no `updated_at` column
      t.datetime "created_at", null: false
    end
  end
end
