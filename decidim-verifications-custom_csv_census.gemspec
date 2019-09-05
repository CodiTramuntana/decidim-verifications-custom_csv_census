# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/verifications/custom_csv_census/version"

Gem::Specification.new do |s|
  s.version = Decidim::Verifications::CustomCsvCensus.version
  s.authors = ["CodiTramuntana"]
  s.email = ["support@coditramuntana.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/coditramuntana/decidim-verifications-custom_csv_census"
  s.required_ruby_version = ">= 2.5.1"

  s.name = "decidim-verifications-custom_csv_census"
  s.summary = "Decidim verifications via uploaded CSV with configurable data"
  s.description = s.summary

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  DECIDIM_VERSION = ">= 0.15.0"

  s.add_dependency "decidim", DECIDIM_VERSION
  s.add_dependency "decidim-admin", DECIDIM_VERSION
  s.add_dependency "decidim-verifications", DECIDIM_VERSION

  s.add_development_dependency "decidim-dev", DECIDIM_VERSION
end
