# frozen_string_literal: true

module SolidWebUi
  # Design-token contract. Every visual value the components use is a CSS custom
  # property `--swui-*` scoped under `.solid-web-ui`. Hosts re-theme by overriding
  # token *values* (Ruby `config.theme`, or their own CSS) — the precompiled
  # stylesheet never needs to be rebuilt because only the values change, not the
  # utilities. Defaults read common host variables first (auto-inheritance) and
  # fall back to a neutral built-in palette.
  module Theme
    # token key => [ css var name, default value ]
    LIGHT = {
      color_primary: [ "--swui-color-primary", "var(--color-primary, #4f46e5)" ],
      color_primary_contrast: [ "--swui-color-primary-contrast", "var(--color-primary-contrast, #ffffff)" ],
      color_bg: [ "--swui-color-bg", "var(--color-bg, #f8fafc)" ],
      color_surface: [ "--swui-color-surface", "var(--color-surface, #ffffff)" ],
      color_text: [ "--swui-color-text", "var(--color-text, #0f172a)" ],
      color_muted: [ "--swui-color-muted", "var(--color-muted, #64748b)" ],
      color_border: [ "--swui-color-border", "var(--color-border, #e2e8f0)" ],
      color_success: [ "--swui-color-success", "var(--color-success, #16a34a)" ],
      color_warning: [ "--swui-color-warning", "var(--color-warning, #d97706)" ],
      color_danger: [ "--swui-color-danger", "var(--color-danger, #dc2626)" ],
      font: [ "--swui-font", "var(--swui-host-font, ui-sans-serif, system-ui, sans-serif)" ],
      radius: [ "--swui-radius", "0.5rem" ]
    }.freeze

    # Dark scheme only re-points the surface/text family; brand color stays.
    DARK = {
      color_bg: [ "--swui-color-bg", "var(--color-bg, #0b0f19)" ],
      color_surface: [ "--swui-color-surface", "var(--color-surface, #151a26)" ],
      color_text: [ "--swui-color-text", "var(--color-text, #e2e8f0)" ],
      color_muted: [ "--swui-color-muted", "var(--color-muted, #94a3b8)" ],
      color_border: [ "--swui-color-border", "var(--color-border, #273043)" ]
    }.freeze

    module_function

    # Serialize the default token contract, with `overrides` (a theme hash) applied.
    def css_vars(overrides = {})
      build(LIGHT, overrides)
    end

    # Dark-scheme token overrides, used inside a dark selector / media query.
    def dark_css_vars(overrides = {})
      build(DARK, overrides)
    end

    def build(table, overrides)
      overrides = (overrides || {}).transform_keys(&:to_sym)
      table.filter_map do |key, (var_name, default)|
        value = overrides.key?(key) ? sanitize(overrides[key]) : default
        value = default if value.nil? || value.empty? # reject unsafe overrides → fall back
        next if value.nil? || value.empty?

        "#{var_name}: #{value};"
      end.join(" ")
    end

    # Allowlist of characters valid in a CSS value (colors, lengths, var()/calc(),
    # font stacks). Anything outside it means a malformed or hostile value, so we
    # reject it entirely (returns nil) rather than trying to scrub it — the token
    # then falls back to its safe default. This makes breaking out of
    # `<style>.solid-web-ui{ … }` impossible.
    SAFE_VALUE = %r{\A[\w\s#%.,()'"/-]*\z}

    def sanitize(value)
      str = value.to_s.strip
      str.match?(SAFE_VALUE) ? str : nil
    end
  end
end
