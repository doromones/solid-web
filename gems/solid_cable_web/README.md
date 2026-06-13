# solid_cable_web

A mountable Rails engine that gives [Solid Cable](https://github.com/rails/solid_cable)
a web dashboard: message and channel counts, recent volume, per-channel activity
and a retention "trim" action. No ActiveAdmin required.

## Install

```ruby
# Gemfile
gem "solid_cable_web"
```

```ruby
# config/routes.rb
mount SolidCableWeb::Engine => "/admin/solid_cable"
```

## Protect it

```ruby
# config/initializers/solid_web.rb
SolidCableWeb.config.base_controller_class = "Admin::BaseController"
```

See [docs/authentication.md](../../docs/authentication.md).

## Configure

```ruby
SolidCableWeb.config.enable_trim = true   # allow trimming old messages
SolidCableWeb.config.retention = 1.day    # messages older than this are trimmable
SolidCableWeb.config.page_title = "WebSockets"
```

Full reference: [docs/configuration.md](../../docs/configuration.md).
Theming: [docs/theming.md](../../docs/theming.md).
