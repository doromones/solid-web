# solid_web_ui

[![Gem Version](https://img.shields.io/gem/v/solid_web_ui)](https://rubygems.org/gems/solid_web_ui)
[![Downloads](https://img.shields.io/gem/dt/solid_web_ui)](https://rubygems.org/gems/solid_web_ui)
[![CI](https://github.com/doromones/solid-web/actions/workflows/ci.yml/badge.svg)](https://github.com/doromones/solid-web/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

Web dashboards for Rails' **Solid Queue**, **Solid Cache** and **Solid Cable** — one gem
(`solid_web_ui`) with three independently mountable Rails engines sharing one design system.

> The repository is named `solid-web`; the gem it ships is `solid_web_ui`.

| Engine | Mount | What it does |
|--------|-------|--------------|
| `SolidWebUi::Queue::Engine` | `/admin/queue` | Solid Queue: dashboard, queues (pause/resume), jobs by status, failed jobs (retry/discard), processes, recurring tasks. |
| `SolidWebUi::Cache::Engine` | `/admin/cache` | Solid Cache: entry/size statistics, entry browser, clear. |
| `SolidWebUi::Cable::Engine` | `/admin/cable` | Solid Cable: message/channel activity, volume, retention trim. |

The shared core (`SolidWebUi`) provides the layout, ViewComponents, design-token theming and a
dry-configurable base. The engines are plain Rails mountable engines — **no ActiveAdmin required**;
host authentication is inherited through a configurable `base_controller_class`.

## Install

```ruby
# Gemfile
gem "solid_web_ui"
```

```ruby
# config/routes.rb — mount only the parts you want
mount SolidWebUi::Queue::Engine => "/admin/queue"
mount SolidWebUi::Cache::Engine => "/admin/cache"
mount SolidWebUi::Cable::Engine => "/admin/cable"
```

```ruby
# config/initializers/solid_web_ui.rb — protect the dashboards behind your auth
SolidWebUi::Queue.config.base_controller_class = "Admin::BaseController"
SolidWebUi::Cache.config.base_controller_class = "Admin::BaseController"
SolidWebUi::Cable.config.base_controller_class = "Admin::BaseController"
```

## Development

A single dummy Rails app under `spec/dummy` (SQLite, schema loaded from the Solid* gems) exercises
all three engines.

```bash
bundle install
bundle exec rspec               # full suite
bundle exec rake assets:build   # rebuild the precompiled Tailwind stylesheet
```

> Requires the Ruby pinned for this workspace. In a non-interactive shell use mise:
> `mise exec -- bundle exec rspec`.

## Releasing

Pushing a version tag builds and releases the gem via
[`.github/workflows/release.yml`](.github/workflows/release.yml):

```bash
git tag v0.1.0
git push origin v0.1.0
```

The workflow builds `solid_web_ui.gem`, attaches it to a GitHub Release, and publishes it to RubyGems
via **OIDC Trusted Publishing** (no API key / secret — MFA-compatible).

One-time setup on [rubygems.org](https://rubygems.org): register a trusted publisher for `solid_web_ui`
(repo `doromones/solid-web`, workflow `release.yml`). Before the first release use a *pending* trusted
publisher (`https://rubygems.org/profile/oidc/pending_trusted_publishers/new`).

## Documentation

- [Configuration reference](docs/configuration.md)
- [Theming — projecting the host design](docs/theming.md)
- [Authentication](docs/authentication.md)
