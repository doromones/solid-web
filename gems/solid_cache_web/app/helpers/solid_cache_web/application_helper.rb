# frozen_string_literal: true

module SolidCacheWeb
  module ApplicationHelper
    def cache_nav(active)
      [
        { label: "Dashboard", href: root_path, active: active == :dashboard },
        { label: "Entries", href: entries_path, active: active == :entries }
      ]
    end

    # Cache keys are stored as binary; present them as readable, truncated text.
    def readable_key(key)
      truncate(key.to_s.dup.force_encoding("UTF-8").scrub("?"), length: 80)
    end

    def short_time(time)
      return "—" if time.nil?

      time.in_time_zone(SolidCacheWeb.config.time_zone).strftime("%Y-%m-%d %H:%M:%S")
    end
  end
end
