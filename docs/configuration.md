# Configuration

Each mountable part is configured with [dry-configurable](https://dry-rb.org/gems/dry-configurable).
Set values in an initializer in your host app, e.g. `config/initializers/solid_web_ui.rb`:

```ruby
SolidWebUi::Queue.config.base_controller_class = "Admin::BaseController"
SolidWebUi::Queue.config.per_page = 50
SolidWebUi::Queue.config.enable_discard = false

SolidWebUi::Cache.config.base_controller_class = "Admin::BaseController"
SolidWebUi::Cable.config.base_controller_class = "Admin::BaseController"
```

## Shared base settings

These come from `SolidWebUi::Configurable` and exist on **all three** web engines
(`SolidWebUi::Queue`, `SolidWebUi::Cache`, `SolidWebUi::Cable`):

| Setting | Type | Default | Purpose |
|---------|------|---------|---------|
| `base_controller_class` | String | `"ActionController::Base"` | Controller the engine inherits, so host authentication/authorization applies. See [authentication.md](authentication.md). |
| `per_page` | Integer | `25` | Page size for paginated lists. |
| `time_zone` | String | `"UTC"` | Time zone used to render timestamps. |
| `page_title` | String | engine-specific | Heading shown at the top of the dashboard. |
| `layout` | String | `"solid_web_ui"` | Layout the dashboard renders in. Set to a host layout (e.g. `"admin"`) to embed the dashboard inside the host chrome — see [Embedding](#embedding-in-a-host-layout). |

## `SolidWebUi::Queue`

| Setting | Type | Default | Purpose |
|---------|------|---------|---------|
| `page_title` | String | `"Solid Queue"` | Dashboard title. |
| `enable_retry` | Boolean | `true` | Allow retrying failed jobs. When `false`, the retry endpoint returns `403`. |
| `enable_discard` | Boolean | `true` | Allow discarding failed jobs. |
| `enable_pause` | Boolean | `true` | Allow pausing/resuming queues. |

## `SolidWebUi::Cache`

| Setting | Type | Default | Purpose |
|---------|------|---------|---------|
| `page_title` | String | `"Solid Cache"` | Dashboard title. |
| `enable_clear` | Boolean | `true` | Allow clearing the whole cache. When `false`, the clear endpoint returns `403`. |

## `SolidWebUi::Cable`

| Setting | Type | Default | Purpose |
|---------|------|---------|---------|
| `page_title` | String | `"Solid Cable"` | Dashboard title. |
| `enable_trim` | Boolean | `true` | Allow trimming old messages. When `false`, the trim endpoint returns `403`. |
| `retention` | Duration | `1.day` | Messages older than this are considered trimmable. |

## Embedding in a host layout

By default each dashboard renders in its own full-page layout. To render it **inside
your app's chrome** (sidebar, header, …), point `layout` at one of your layouts:

```ruby
SolidWebUi::Queue.config.layout = "admin"
SolidWebUi::Cache.config.layout = "admin"
SolidWebUi::Cable.config.layout = "admin"
```

Two requirements on that host layout:

1. Add the dashboards' assets to its `<head>`:

   ```erb
   <%= solid_web_ui_head_tags %>
   ```

   (Available app-wide — it links the bundled stylesheet and emits the theme tokens.)

2. Reference the host's **own** routes via `main_app.` (the dashboards are isolated
   engines, so unqualified app route helpers don't resolve from their context):

   ```erb
   <%= link_to "Home", main_app.root_path %>
   ```

The dashboard content is self-scoped under `.solid-web-ui`, so its styling never
leaks into the rest of the host layout.

## Theming settings

Theming lives on `SolidWebUi.config` and applies to all three dashboards — see
[theming.md](theming.md):

| Setting | Type | Default | Purpose |
|---------|------|---------|---------|
| `theme` | Hash | `{}` | Design-token value overrides, e.g. `{ color_primary: "#7c3aed" }`. The `page_max_width` token (default `72rem`) caps the centered page column — set it to `"none"` or `"100%"` to let the dashboards fill their container when embedded in a wide host layout. |
| `color_scheme` | String | `"auto"` | `"auto"` \| `"light"` \| `"dark"`. |
| `stylesheet` | Boolean | `true` | Link the bundled stylesheet. `false` lets the host style everything. |
| `extra_stylesheets` | Array | `[]` | Extra Propshaft stylesheet names linked after the bundled one. |

## Live auto-refresh

Each dashboard polls itself so the stats, queues and tables stay current without a
manual reload. The page header carries a frequency `<select>`, a countdown to the
next refresh and a manual refresh button; only the data region (a turbo-frame) is
reloaded — morphed in place when [Turbo](https://turbo.hotwired.dev) is on the page,
otherwise fetched and swapped. The chosen interval is remembered per browser, and
polling pauses while the tab is hidden. The bundled JS is linked by
`solid_web_ui_head_tags` alongside the stylesheet.

These settings live on `SolidWebUi.config` and apply to all three dashboards:

| Setting | Type | Default | Purpose |
|---------|------|---------|---------|
| `javascript` | Boolean | `true` | Link the bundled live-refresh JS. `false` ships no JS (static dashboards). |
| `refresh_interval` | Integer | `10` | Pre-selected refresh interval in **seconds**; `0` starts with auto-refresh off. |
| `refresh_intervals` | Array | `[0, 2, 5, 10, 30, 60]` | Choices offered in the frequency `<select>` (seconds; `0` = Off). |

The controls are added by `SolidWebUi::Ui::PageComponent` (via `swui_page`), which
wraps the page body in the refreshable frame. Pass `swui_page(..., refresh: false)`
for a page that should not auto-refresh.
