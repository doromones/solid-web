source "https://rubygems.org"

# The four gems of this monorepo, wired locally via path.
%w[solid_web_ui solid_queue_web solid_cache_web solid_cable_web].each do |gem_name|
  gem gem_name, path: "gems/#{gem_name}"
end

# Test database for the dummy app (decoupled from any host DB choice).
gem "sqlite3", ">= 2.0"
gem "puma"

group :development, :test do
  gem "rspec-rails"
  gem "capybara"
  gem "rackup"
  gem "rubocop", require: false
  gem "rubocop-rails-omakase", require: false
  # Vendors the Tailwind 4 standalone CLI used by bin/build-css to precompile
  # the shared stylesheet. Build-time only — never a runtime gem dependency.
  gem "tailwindcss-ruby", require: false
  # Component gallery for the shared ViewComponents (dev/preview only).
  gem "lookbook"
end
