# frozen_string_literal: true

# This initializer is used for configuring the test app.
Decidim::Verifications::CustomCsvCensus.configure do |config|
  # `config.col_sep = ","` is the default CSV column separator.
  config.fields = {
    id_document: {
      type: String,
      search: true,
      format: /\A[A-Z0-9]*\z/
    }
  }
end
