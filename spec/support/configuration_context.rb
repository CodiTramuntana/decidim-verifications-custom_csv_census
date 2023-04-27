# frozen_string_literal: true

shared_context "with configured fields" do
  let(:default_fields) do
    {
      id_document: {
        type: String,
        search: true,
        format: /\A[A-Z0-9]*\z/
      }
    }
  end

  let(:custom_fields) { defined?(fields) ? fields : default_fields }

  before do
    Decidim::CustomCsvCensus.configure do |config|
      config.fields = custom_fields
    end
  end

  include_context "with table"
end

shared_context "with table" do
  let(:table_name) { :decidim_verifications_custom_csv_census_census_data }
  let(:table_definition) do
    custom_fields = Decidim::CustomCsvCensus.configuration.fields
    indexes = custom_fields.select { |_k, v| v[:search] }.keys.push(:decidim_organization_id)
    proc do |t|
      t.references :decidim_organization, index: { name: "census_data_org_id_index" }
      # custom fields
      custom_fields.each do |name, options|
        t.send(options[:type].to_s.downcase, name)
      end
      t.send(:index, indexes, unique: true, name: "index")
      # custom fields
      t.datetime :created_at, null: false
    end
  end

  before do
    ActiveRecord::Migration.suppress_messages do
      ActiveRecord::Migration.create_table(table_name, &table_definition)
    end
  end
end
