# solid-web

Web dashboards for Rails' **Solid Queue**, **Solid Cache** and **Solid Cable**, packaged as three
independent mountable engine gems plus a shared design gem.

| Gem | What it does |
|-----|--------------|
| [`solid_web_ui`](gems/solid_web_ui) | Shared base: layout, ViewComponents, design tokens / theming, dry-configurable base, precompiled Tailwind CSS. The other three depend on it. |
| [`solid_queue_web`](gems/solid_queue_web) | Dashboard for Solid Queue: jobs, queues, failed executions, processes, recurring tasks. |
| [`solid_cache_web`](gems/solid_cache_web) | Dashboard for Solid Cache: entries, size statistics, maintenance. |
| [`solid_cable_web`](gems/solid_cable_web) | Dashboard for Solid Cable: channel activity, message volume, retention. |

The three web engines are plain Rails mountable engines — **no ActiveAdmin required**. Host
authentication is inherited through a configurable `base_controller_class`. They are tied together
visually by depending on `solid_web_ui`.

## Development

This is a monorepo; the four gems are wired locally via `path:` in the root `Gemfile`, and exercised
by a single dummy Rails app under `spec/dummy` (SQLite, schema loaded from the Solid* gems).

```bash
bundle install
bundle exec rspec        # runs the specs of all four gems
bundle exec rake assets:build   # rebuild the precompiled Tailwind stylesheet
```

> Requires the Ruby pinned for this workspace. In a non-interactive shell use mise:
> `mise exec -- bundle exec rspec`.

## Releasing

The four gems share a single version. Pushing a version tag builds and releases
them via [`.github/workflows/release.yml`](.github/workflows/release.yml):

```bash
git tag v0.1.0
git push origin v0.1.0
```

The workflow builds the four `.gem` files, attaches them to a GitHub Release, and
publishes them to RubyGems via **OIDC Trusted Publishing** (no API key / secret —
MFA-compatible), `solid_web_ui` first as the others depend on it.

One-time setup on [rubygems.org](https://rubygems.org): register a trusted publisher
for **each** gem name (repo `doromones/solid-web`, workflow `release.yml`). For
gems not yet published, use a *pending* trusted publisher
(`https://rubygems.org/profile/oidc/pending_trusted_publishers/new`).

## Documentation

- [Configuration reference](docs/configuration.md)
- [Theming — projecting the host design](docs/theming.md)
- [Authentication](docs/authentication.md)
