# Configuration

Every gem is configured with [dry-configurable](https://dry-rb.org/gems/dry-configurable).
Set values in an initializer in your host app, e.g. `config/initializers/solid_web.rb`:

```ruby
SolidQueueWeb.config.base_controller_class = "Admin::BaseController"
SolidQueueWeb.config.per_page = 50
SolidQueueWeb.config.enable_discard = false

SolidCacheWeb.config.base_controller_class = "Admin::BaseController"
SolidCableWeb.config.base_controller_class = "Admin::BaseController"
```

## Shared base settings

These come from `SolidWebUi::Configurable` and exist on **all three** web engines
(`SolidQueueWeb`, `SolidCacheWeb`, `SolidCableWeb`):

| Setting | Type | Default | Purpose |
|---------|------|---------|---------|
| `base_controller_class` | String | `"ActionController::Base"` | Controller the engine inherits, so host authentication/authorization applies. See [authentication.md](authentication.md). |
| `per_page` | Integer | `25` | Page size for paginated lists. |
| `time_zone` | String | `"UTC"` | Time zone used to render timestamps. |
| `page_title` | String | engine-specific | Heading shown at the top of the dashboard. |

## `SolidQueueWeb`

| Setting | Type | Default | Purpose |
|---------|------|---------|---------|
| `page_title` | String | `"Solid Queue"` | Dashboard title. |
| `enable_retry` | Boolean | `true` | Allow retrying failed jobs. When `false`, the retry endpoint returns `403`. |
| `enable_discard` | Boolean | `true` | Allow discarding failed jobs. |
| `enable_pause` | Boolean | `true` | Allow pausing/resuming queues. |

## `SolidCacheWeb`

| Setting | Type | Default | Purpose |
|---------|------|---------|---------|
| `page_title` | String | `"Solid Cache"` | Dashboard title. |
| `enable_clear` | Boolean | `true` | Allow clearing the whole cache. When `false`, the clear endpoint returns `403`. |

## `SolidCableWeb`

| Setting | Type | Default | Purpose |
|---------|------|---------|---------|
| `page_title` | String | `"Solid Cable"` | Dashboard title. |
| `enable_trim` | Boolean | `true` | Allow trimming old messages. When `false`, the trim endpoint returns `403`. |
| `retention` | Duration | `1.day` | Messages older than this are considered trimmable. |

## Theming settings

Theming lives on `SolidWebUi.config` and applies to all three dashboards — see
[theming.md](theming.md):

| Setting | Type | Default | Purpose |
|---------|------|---------|---------|
| `theme` | Hash | `{}` | Design-token value overrides, e.g. `{ color_primary: "#7c3aed" }`. |
| `color_scheme` | String | `"auto"` | `"auto"` \| `"light"` \| `"dark"`. |
| `stylesheet` | Boolean | `true` | Link the bundled stylesheet. `false` lets the host style everything. |
| `extra_stylesheets` | Array | `[]` | Extra Propshaft stylesheet names linked after the bundled one. |
