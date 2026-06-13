# Theming — projecting the host design

The dashboards are styled with a small set of **design tokens** exposed as CSS
custom properties (`--swui-*`), scoped under the `.solid-web-ui` wrapper. The
bundled stylesheet only ever *reads* these tokens, so you re-theme by overriding
their **values** — the precompiled CSS is never rebuilt.

## Token contract

| Token | CSS variable | Default (light) |
|-------|--------------|-----------------|
| `color_primary` | `--swui-color-primary` | `var(--color-primary, #4f46e5)` |
| `color_primary_contrast` | `--swui-color-primary-contrast` | `#ffffff` |
| `color_bg` | `--swui-color-bg` | `#f8fafc` |
| `color_surface` | `--swui-color-surface` | `#ffffff` |
| `color_text` | `--swui-color-text` | `#0f172a` |
| `color_muted` | `--swui-color-muted` | `#64748b` |
| `color_border` | `--swui-color-border` | `#e2e8f0` |
| `color_success` | `--swui-color-success` | `#16a34a` |
| `color_warning` | `--swui-color-warning` | `#d97706` |
| `color_danger` | `--swui-color-danger` | `#dc2626` |
| `font` | `--swui-font` | system sans-serif stack |
| `radius` | `--swui-radius` | `0.5rem` |

Each color default reads a conventional host variable first
(`var(--color-primary, …)`), so if your app already defines those, the dashboards
inherit them automatically (level 3 below).

## Three ways to theme (use any combination)

### 1. Ruby config (recommended, no CSS needed)

```ruby
SolidWebUi.config.theme = {
  color_primary: "#7c3aed",
  color_bg:      "#0b0b0f",
  color_surface: "#16161d",
  font:          "'Inter', sans-serif",
  radius:        "0.375rem"
}
```

The layout renders these as scoped CSS variables. Values are sanitized (anything
outside a safe CSS-value allowlist is rejected and falls back to the default), so
this is safe even with user-provided input.

### 2. Override the CSS variables yourself

```css
.solid-web-ui {
  --swui-color-primary: var(--my-brand-accent);
  --swui-font: var(--my-app-font);
}
```

### 3. Automatic inheritance

If your app already exposes `--color-primary`, `--color-bg`, `--color-surface`,
etc., the dashboards pick them up with no configuration, via the fallback in each
token default.

## Dark mode

```ruby
SolidWebUi.config.color_scheme = "dark"   # or "light", or "auto" (default)
```

`"auto"` follows the OS via `@media (prefers-color-scheme: dark)`. Dark mode only
re-points the surface/text token family; your brand color is preserved. The markup
never changes.

## Full takeover (escape hatch)

```ruby
SolidWebUi.config.stylesheet = false                    # drop the bundled CSS entirely
SolidWebUi.config.extra_stylesheets = [ "admin/solid" ] # ship your own
```

The component markup uses stable `swui-*` class names you can target.

## Rebuilding the bundled stylesheet

The stylesheet is authored in Tailwind 4 (`tailwind/application.css`) and
**precompiled** into `gems/solid_web_ui/app/assets/stylesheets/solid_web_ui.css`,
which is committed and shipped with the gem — host apps need no Tailwind setup. To
regenerate after editing the source:

```bash
bin/build-css          # or: bundle exec rake assets:build
```
