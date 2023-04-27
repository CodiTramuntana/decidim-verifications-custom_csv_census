# frozen_string_literal: true

# This initializer is used for configuring the test app.
Decidim::CustomCsvCensus.configure do |config|
  # `config.col_sep = ","` is the default CSV column separator.
  config.fields = {
    id_document: {
      type: String,
      search: true,
      encoded: true,
      format: /\A[A-Z0-9]*\z/
    },
    favourite_color: {
      type: String,
      search: false,
      encoded: false
    },
    birth_date: {
      type: Date,
      search: true,
      encoded: false,
      format: %r{\d{2}/\d{2}/\d{4}},
      parse: proc { |s| s.to_date }
    }
  }
end
