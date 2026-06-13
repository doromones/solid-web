# solid_web_ui

Shared design system and base engine for the Solid* web dashboards
([`solid_queue_web`](../solid_queue_web), [`solid_cache_web`](../solid_cache_web),
[`solid_cable_web`](../solid_cable_web)). You normally don't install this directly —
it comes in as a dependency of the three dashboards — but it's what ties them
together visually and behaviourally.

It provides:

- a shared layout and a set of ViewComponents (`SolidWebUi::Ui::*`): stat cards,
  tables, status badges, pagination, page chrome;
- a precompiled, self-contained Tailwind 4 stylesheet (no Tailwind setup needed in
  the host), scoped under `.solid-web-ui`;
- a design-token theming system (`SolidWebUi::Theme`) — see
  [docs/theming.md](../../docs/theming.md);
- the `dry-configurable` base (`SolidWebUi::Configurable`) the engines extend;
- a tiny offset `SolidWebUi::Paginator` (no kaminari/pagy dependency);
- `SolidWebUi.resolve_base_controller` for host-auth inheritance.

## Theming

```ruby
SolidWebUi.config.theme = { color_primary: "#7c3aed" }
SolidWebUi.config.color_scheme = "auto"   # auto | light | dark
```

See [docs/theming.md](../../docs/theming.md) and
[docs/configuration.md](../../docs/configuration.md).
