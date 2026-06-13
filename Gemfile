source "https://rubygems.org"

# The gem itself (runtime deps come from solid_web_ui.gemspec).
gemspec

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
