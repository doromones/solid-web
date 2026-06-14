# frozen_string_literal: true

module SolidWebUi::Cache
  module ApplicationHelper
    def cache_nav(active)
      [
        { label: "Dashboard", href: root_path, active: active == :dashboard },
        { label: "Entries", href: entries_path, active: active == :entries }
      ]
    end

    # Cache keys are stored as binary; present them as readable, truncated text.
    def readable_key(key, length: 80)
      truncate(key.to_s.dup.force_encoding("UTF-8").scrub("?"), length: length)
    end

    # Cache values are binary (often a Marshal/compressed blob). Present a scrubbed,
    # truncated preview so the show page never dumps megabytes of unreadable bytes.
    def readable_value(value, length: 2000)
      truncate(value.to_s.dup.force_encoding("UTF-8").scrub("?"), length: length)
    end

    def short_time(time)
      return "—" if time.nil?

      time.in_time_zone(SolidWebUi::Cache.config.time_zone).strftime("%Y-%m-%d %H:%M:%S")
    end
  end
end
