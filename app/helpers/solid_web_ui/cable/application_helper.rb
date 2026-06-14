# frozen_string_literal: true

module SolidWebUi::Cable
  module ApplicationHelper
    def cable_nav(active)
      [
        { label: "Dashboard", href: root_path, active: active == :dashboard },
        { label: "Channels", href: channels_path, active: active == :channels }
      ]
    end

    def readable_channel(channel, length: 80)
      truncate(channel.to_s.dup.force_encoding("UTF-8").scrub("?"), length: length)
    end

    # Cable payloads are binary; present a scrubbed, truncated preview.
    def readable_payload(payload, length: 120)
      truncate(payload.to_s.dup.force_encoding("UTF-8").scrub("?"), length: length)
    end

    def short_time(time)
      return "—" if time.nil?

      time.in_time_zone(SolidWebUi::Cable.config.time_zone).strftime("%Y-%m-%d %H:%M:%S")
    end
  end
end
