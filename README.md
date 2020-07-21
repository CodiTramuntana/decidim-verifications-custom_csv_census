# Decidim::Verifications::CustomCsvCensus

The gem has been developed by [CodiTramuntana](https://coditramuntana.com).

`Decidim::Verifications::CustomCsvCensus` is a [Decidim](https://github.com/decidim/decidim) module to allow uploading a CSV file to perform verifications against data that can be configured at installation level. It is inspired in [Decidim File Authorization Handler](https://github.com/MarsBased/decidim-file_authorization_handler/) gem and based on the [Decidim::Verifications](https://github.com/decidim/decidim/tree/master/decidim-verifications#decidimverifications) module.

## Usage

The module provides a model `Decidim::Verifications::CensusDatum` to store census information. Then, in the auhtorization form `Decidim::Verifications::CustomCsvCensus::CustomCsvCensusAuthorizationHandler` the user input will be used to search for that data model. Stored data can be persisted in a hashed way.

It also provides a model `Decidim::Verifications::CensusDataReport` used to trace the actions (create and delete) of the admins regarding the census. This information will be shown in the admin logs.

It has an admin controller to upload CSV files with the information and it ignores duplicates when importing new data.

The uploaded file is processed when the file is uploaded. Uploading the file to a temporary storage system and processing it in background is kept out of the scope for the first release.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decidim-verifications-custom_csv_census', git: 'git@github.com:CodiTramuntana/decidim-verifications-custom_csv_census.git'
```

Configure the CSV fields by creating an initializer in `config/initializers/custom_csv_census.rb`.


And then execute:

```bash
bundle
bin/rails custom_csv_census:init
```

## Configuration

This [example](config/custom_csv_census_initializer_example.rb) shows a standard usecase:

```ruby
# config/initializers/decidim_verifications_custom_csv_census.rb
Decidim::Verifications::CustomCsvCensus.configure do |config|
  # `config.col_sep = ","` is the default CSV column separator.
  config.fields = {
    id_document: {
      type: String,
      search: true,
      encoded: true,
      format: /\A[A-Z0-9]*\z/
    }
  }
end
```

The configuration option `fields` must be a `Hash`: the key must be the name of the field and the value must be another `Hash` of options; all options must contain the key-value `type` and at least one of them must contain `search: true`. With these requirements met we can execute `bin/rails custom_csv_census:init` and will have a working gem.

Additional options are:
- `format`, a `Regexp` used to validate both the CSV value while importing and the input of the user while authorizing (recommended).
- `encoded`, whether to apply a hash function to this value before persisting it.
- `parse`, a `Proc` used to process the CSV value while importing.
- `parse_first`, a `Boolean` to decide wether to parse the field before validating the format while importing.
  - You could want to do it beforehand to clean the incoming data.
  - You could want to do it afterwards to further transform clean data.

**Translations**
- You need to provide translations for your configured fields using the following locale key `activemodel.attributes.custom_csv_census_authorization_handler.<field_name>`
- You need to provide translations for format errors if you have configured the `format` option using the following locale key: `errors.messages.<field_name>_format`

## How it works

Decidim implements two type of authorization methods:
- Form authorizations, used when the authorization can be granted with the submission of a single form, called authorization handler.
- Workflow authorizations, used when the authorization requires admin intervention.

This module is technically a workflow authorization because it implements an admin engine, but it can also be considered a form authorization as the main engine's controller [inherits](app/controllers/decidim/verifications/custom_csv_census/authorizations_controller.rb) from `Decidim::Verifications::AuthorizationsController` since it make it easier to find the authorization form for the base controller in order to treat it as an authorization handler. This is because the base authorization scheme is perfect for the module needs and it is also why the workflow name is _custom_csv_census_authorization_handler_ and not _custom_csv_census_, so the Decidim's Verifications Engine recognizes our authorization form as an authorization handler.

The default behaviour of the authorization form is to search the database for the census data using the user inputted data that corresponds with the configured fields that have the option `search: true`; if the census data is found the user is authorized. However, if that is not enough, you can extend the form to add more validations, like so:

```ruby
# config/initializers/decidim_verifications_custom_csv_census.rb
Decidim::Verifications::CustomCsvCensus::CustomCsvCensusAuthorizationHandler.class_eval do
  # Assuming you have configured the following field:
  #   birthdate: {
  #     type: Date,
  #     search: false,
  #     format: %r{\d{2}\/\d{2}\/\d{4}},
  #     parse: proc { |s| s.to_date }
  #   }
  validate :user_must_be_of_legal_age

  private

  def user_must_be_of_legal_age
    return unless census_for_user

    age_in_years = Date.current.year - census_for_user.birthdate.year
    errors.add(:birthdate, I18n.t("errors.messages.age")) if age_in_years < 18
  end
end
```

You can also inject data to the `Decidim::Authorization` `metadata` field and override the [authorization workflow](lib/decidim/verifications/custom_csv_census/workflow.rb) to add a [custom action authorizer](https://github.com/decidim/decidim/tree/master/decidim-verifications#custom-action-authorizers) so you can change the authorization logic when setting a verification method in the admin zone for a given component action. Like so:

```ruby
# config/initializers/decidim_verifications_custom_csv_census.rb
Decidim::Verifications.register_workflow(:custom_csv_census_authorization_handler) do |workflow|
  workflow.action_authorizer = "Decidim::Verifications::CustomCsvCensus::ActionAuthorizer"
end

# app/services/decidim/verifications/custom_csv_census/action_authorizer.rb
module Decidim
  module Verifications
    module CustomCsvCensus
      class ActionAuthorizer < DefaultActionAuthorizer
        # See the documentation for the parent class for implementation ideas.
      end
    end
  end
end
```

## Run tests

Create a dummy app in your application (if not present):

```bash
bin/rails test_app
```

This will produce the dummy app and copy the `config/custom_csv_census_initializer_example.rb` initializer in the dummy_app.
It will also produce and execute the custom_csv_census migrations.

And run tests with `bundle exec rspec`

## License

AGPLv3 (same as Decidim)
