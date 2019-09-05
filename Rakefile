# frozen_string_literal: true

require "decidim/dev/common_rake"

task test_app: "decidim:generate_external_test_app" do
  filename = File.join(Dir.pwd, "config", "custom_csv_census_initializer_example.rb")
  ENV["RAILS_ENV"] = "test"
  Dir.chdir("spec/decidim_dummy_app") do
    dest_folder = File.join(Dir.pwd, "config", "initializers")
    FileUtils.cp(filename, dest_folder)
    system("bundle exec rake custom_csv_census:init")
  end
end
