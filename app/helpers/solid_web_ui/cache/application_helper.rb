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

    # Absolute expiry of a cache entry (see EntriesController#entry_expiry).
    def cache_expires_at(expiry)
      case expiry
      when Numeric then short_time(Time.at(expiry))
      when :never  then "Never"
      else "—"
      end
    rescue StandardError
      "—" # a corrupt/out-of-range epoch shouldn't break the list
    end

    # Remaining time until a cache entry expires, e.g. "about 2 hours" / "expired".
    def cache_time_to_expire(expiry)
      return "—" unless expiry.is_a?(Numeric)

      remaining = expiry - Time.now.to_f
      return "expired" if remaining <= 0

      distance_of_time_in_words(remaining)
    end

    def short_time(time)
      return "—" if time.nil?

      time.in_time_zone(SolidWebUi::Cache.config.time_zone).strftime("%Y-%m-%d %H:%M:%S")
    end
  end
end
