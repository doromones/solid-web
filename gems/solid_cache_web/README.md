# solid_cache_web

A mountable Rails engine that gives [Solid Cache](https://github.com/rails/solid_cache)
a web dashboard: entry count and total/average size, oldest/newest entries, an
entry browser and a "clear cache" action. No ActiveAdmin required.

## Install

```ruby
# Gemfile
gem "solid_cache_web"
```

```ruby
# config/routes.rb
mount SolidCacheWeb::Engine => "/admin/solid_cache"
```

## Protect it

```ruby
# config/initializers/solid_web.rb
SolidCacheWeb.config.base_controller_class = "Admin::BaseController"
```

See [docs/authentication.md](../../docs/authentication.md).

## Configure

```ruby
SolidCacheWeb.config.per_page = 50
SolidCacheWeb.config.enable_clear = true   # allow clearing the whole cache
SolidCacheWeb.config.page_title = "Cache"
```

Full reference: [docs/configuration.md](../../docs/configuration.md).
Theming: [docs/theming.md](../../docs/theming.md).
