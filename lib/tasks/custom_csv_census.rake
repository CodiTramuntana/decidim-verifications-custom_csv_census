# frozen_string_literal: true

namespace :custom_csv_census do
  task init: ["generate:custom_migration", "decidim_verifications_custom_csv_census:install:migrations", "db:migrate"]

  namespace :generate do
    desc "Generates a customized migration"
    task custom_migration: :environment do
      gem_root = Gem::Specification.find_by_name("decidim-verifications-custom_csv_census").gem_dir
      default_migration_name = +"create_decidim_verifications_custom_csv_census_census_data.rb"
      default_migration_path = File.join(gem_root, "db", default_migration_name)
      text = File.read(default_migration_path)

      indexes = custom_fields.select { |_k, v| v[:search] }.keys.push(:decidim_organization_id)
      columns = custom_fields.map { |name, options| "t.#{options[:type].to_s.downcase} :#{name}" }
      replacement = columns.push("t.index #{indexes}, unique: true, name: 'index'").join("\n      ")

      timestamp = Time.now.utc.to_s(:number)
      new_migration_name = default_migration_name.prepend(timestamp, "_")
      file_name = Rails.root.join("db", "migrate", new_migration_name)
      File.write(file_name.to_s, text.gsub("# replace me", replacement)) unless File.exist?(file_name)
      puts "Created migration #{file_name.basename}"
    end

    def custom_fields
      Decidim::Verifications::CustomCsvCensus.configuration.fields
    end
  end
end
