# frozen_string_literal: true

require "spec_helper"
require "rake"

describe "custom_csv_census" do
  describe "generate:custom_migration" do
    let(:task) { "custom_csv_census:generate:custom_migration" }
    let(:invoke_task) { Rake.application.invoke_task(task) }

    before do
      Rake.application.rake_require "tasks/custom_csv_census"
      Rake::Task.define_task(:environment)
      allow(STDOUT).to receive(:puts)
      allow(File).to receive(:write)
    end

    it "should create a migration and put custom fields in it" do
      expect(File).to receive(:write).with(
        /_create_decidim_verifications_custom_csv_census_census_data.decidim_verifications_custom_csv_census.rb/,
        /t.string :id_document/
      )

      invoke_task
    end
  end
end
