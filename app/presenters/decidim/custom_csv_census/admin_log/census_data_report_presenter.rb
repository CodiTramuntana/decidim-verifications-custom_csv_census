# frozen_string_literal: true

module Decidim
  module CustomCsvCensus
    module AdminLog
      # This class holds the logic to present a `RedirectRule` for the `AdminLog` log.
      class CensusDataReportPresenter < Decidim::Log::BasePresenter
        private

        delegate :url_helpers, to: "Decidim::CustomCsvCensus::AdminEngine.routes"

        def diff_fields_mapping
          case action
          when "create"
            {
              num_inserts: :integer,
              num_invalid: :integer
            }
          when "delete"
            {
              num_deleted: :integer,
              num_revoked: :integer
            }
          end
        end

        def action_string
          case action
          when "create", "delete"
            "#{i18n_labels_scope}.#{action}"
          end
        end

        # Private: The params to be sent to the i18n string.
        #
        # Returns a Hash.
        def i18n_params
          {
            user_name: user_presenter.present,
            resource_name: present_resource
          }
        end

        # Private: Presents the resource of the action.
        #
        # Returns an HTML-safe String.
        def present_resource
          h.content_tag(:span, link_to_census, class: "logs__log__resource")
        end

        # Private: Renders a link to the custom_csv_census_path.
        #
        # Returns an HTML-safe String.
        def link_to_census
          h.link_to(
            I18n.t("decidim.authorization_handlers.custom_csv_census.name"),
            url_helpers.custom_csv_census_path
          )
        end

        # Private: Calculates if the diff has to be shown or not.
        #
        # Returns a Boolean.
        def has_diff?
          action_log.version.present?
        end

        # Private: Calculates whether the diff should show the previous value
        # or not, based on the current action name.
        #
        # Returns a Boolean.
        def show_previous_value_in_diff?
          false
        end

        # Private: The I18n scope where the resource fields are found, so
        # the diff can properly generate the labels.
        #
        # Returns a String.
        def i18n_labels_scope
          "decidim.custom_csv_census.admin_log"
        end
      end
    end
  end
end
