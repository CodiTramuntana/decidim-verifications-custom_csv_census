# frozen_string_literal: true

require "decidim/dev"

ENV["ENGINE_NAME"] = File.dirname(__dir__).split("/").last

Decidim::Dev.dummy_app_path = File.expand_path(File.join(Dir.pwd, "spec", "decidim_dummy_app"))

require "decidim/dev/test/base_spec_helper"

Dir[File.join(Dir.pwd, "spec", "support", "/*.rb")].each { |f| require f }

# RSpec.configure do |config|
#   config.before(:suite) do
#     ActiveRecord::Migration.suppress_messages do
#       unless ActiveRecord::Base.connection.data_source_exists?("decidim_verifications_custom_csv_census_census_data")
#         ActiveRecord::Migration.create_table :decidim_verifications_custom_csv_census_census_data do |t|
#           t.references :decidim_organization, index: { name: "census_data_org_id_index" }
#           # custom fields
#           t.string :id_document
#           t.index %i[id_document decidim_organization_id], unique: true, name: "index"
#           # custom fields
#           t.datetime :created_at, null: false
#         end
#       end
#     end
#   end
# end
