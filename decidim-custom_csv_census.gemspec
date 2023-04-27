# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/custom_csv_census/version"

Gem::Specification.new do |s|
  s.version = Decidim::CustomCsvCensus::VERSION
  s.authors = ["CodiTramuntana"]
  s.email = ["support@coditramuntana.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/Platoniq/decidim-verifications-custom_csv_census"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-custom_csv_census"
  s.summary = "A decidim custom_csv_census module"
  s.description = "Decidim verifications via uploaded CSV with configurable data."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim", Decidim::CustomCsvCensus::COMPAT_DECIDIM_VERSION
  s.add_dependency "decidim-admin", Decidim::CustomCsvCensus::COMPAT_DECIDIM_VERSION
  s.add_dependency "decidim-core", Decidim::CustomCsvCensus::COMPAT_DECIDIM_VERSION
  s.add_dependency "decidim-verifications", Decidim::CustomCsvCensus::COMPAT_DECIDIM_VERSION

  s.add_development_dependency "decidim-dev", Decidim::CustomCsvCensus::COMPAT_DECIDIM_VERSION
end
