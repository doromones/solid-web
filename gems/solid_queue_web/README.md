# solid_queue_web

A mountable Rails engine that gives [Solid Queue](https://github.com/rails/solid_queue)
a web dashboard: status overview, queues (with pause/resume), jobs by status,
failed jobs (with retry/discard), processes and recurring tasks. No ActiveAdmin
required.

## Install

```ruby
# Gemfile
gem "solid_queue_web"
```

```ruby
# config/routes.rb
mount SolidQueueWeb::Engine => "/admin/solid_queue"
```

## Protect it

The engine has no auth of its own. Point it at a controller that enforces yours:

```ruby
# config/initializers/solid_web.rb
SolidQueueWeb.config.base_controller_class = "Admin::BaseController"
```

See [docs/authentication.md](../../docs/authentication.md).

## Configure

```ruby
SolidQueueWeb.config.per_page = 50
SolidQueueWeb.config.enable_retry = true     # retry failed jobs
SolidQueueWeb.config.enable_discard = true   # discard failed jobs
SolidQueueWeb.config.enable_pause = true     # pause/resume queues
SolidQueueWeb.config.page_title = "Background jobs"
```

Full reference: [docs/configuration.md](../../docs/configuration.md).
Theming: [docs/theming.md](../../docs/theming.md).
