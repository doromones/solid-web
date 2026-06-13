# frozen_string_literal: true

module SolidWebUi
  # Emits the dashboards' stylesheet + theme tokens. Included into ActionView
  # app-wide (see SolidWebUi::Engine) so a host layout can drop
  # `<%= solid_web_ui_head_tags %>` into its <head> when rendering the dashboards
  # inside its own chrome (config.layout = "your_layout").
  #
  # Defined in lib/ (not app/helpers) because it is mixed into ActionView during
  # boot, before the engine's autoload paths are ready.
  module HeadHelper
    def solid_web_ui_head_tags
      tags = []
      if SolidWebUi.config.stylesheet
        tags << stylesheet_link_tag("solid_web_ui", "data-turbo-track": "reload")
      end
      Array(SolidWebUi.config.extra_stylesheets).each do |sheet|
        tags << stylesheet_link_tag(sheet, "data-turbo-track": "reload")
      end
      tags << solid_web_ui_theme_style_tag
      safe_join(tags)
    end

    private

    def solid_web_ui_theme_style_tag
      theme = SolidWebUi.config.theme
      css = +".solid-web-ui { #{SolidWebUi::Theme.css_vars(theme)} }"
      case SolidWebUi.config.color_scheme.to_s
      when "dark"
        css << " .solid-web-ui { #{SolidWebUi::Theme.dark_css_vars(theme)} }"
      when "auto"
        css << " @media (prefers-color-scheme: dark) { .solid-web-ui { #{SolidWebUi::Theme.dark_css_vars(theme)} } }"
      end
      content_tag(:style, css.html_safe) # rubocop:disable Rails/OutputSafety
    end
  end
end
