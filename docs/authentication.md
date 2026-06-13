# Authentication

The engines ship **no** authentication of their own — they are dashboards over
sensitive operational data, so you must protect them. There is no ActiveAdmin
dependency; instead each engine inherits from a controller you choose.

## `base_controller_class`

Each engine's controllers inherit from the class named by `base_controller_class`
(default `"ActionController::Base"`). Point it at a controller that enforces your
auth and the dashboards inherit it:

```ruby
# config/initializers/solid_web.rb
SolidWebUi::Queue.config.base_controller_class = "Admin::BaseController"
SolidWebUi::Cache.config.base_controller_class = "Admin::BaseController"
SolidWebUi::Cable.config.base_controller_class = "Admin::BaseController"
```

```ruby
# app/controllers/admin/base_controller.rb
class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!   # Devise, Pundit, your own — anything
end
```

The class name is resolved lazily (the first time an engine controller is loaded),
so it just needs to be defined by the time the app serves a request — an
initializer is the right place to set it.

## Devise example

```ruby
# config/initializers/solid_web.rb
%w[SolidWebUi::Queue SolidWebUi::Cache SolidWebUi::Cable].each do |engine|
  engine.constantize.config.base_controller_class = "Admin::DashboardController"
end
```

```ruby
class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action { head :forbidden unless current_user.admin? }
end
```

## Route-level constraint (alternative)

You can also gate at the routing layer instead of (or in addition to) the
controller:

```ruby
authenticate :user, ->(u) { u.admin? } do
  mount SolidWebUi::Queue::Engine => "/admin/solid_queue"
  mount SolidWebUi::Cache::Engine => "/admin/solid_cache"
  mount SolidWebUi::Cable::Engine => "/admin/solid_cable"
end
```

## Disabling destructive actions

Even behind auth, you can turn off the destructive endpoints per engine — see
[configuration.md](configuration.md): `enable_retry`, `enable_discard`,
`enable_pause`, `enable_clear`, `enable_trim`. A disabled endpoint returns `403`.
