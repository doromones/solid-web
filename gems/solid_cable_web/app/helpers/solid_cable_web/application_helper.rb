# frozen_string_literal: true

module SolidCableWeb
  module ApplicationHelper
    def cable_nav(active)
      [
        { label: "Dashboard", href: root_path, active: active == :dashboard },
        { label: "Channels", href: channels_path, active: active == :channels }
      ]
    end

    def readable_channel(channel)
      truncate(channel.to_s.dup.force_encoding("UTF-8").scrub("?"), length: 80)
    end

    def short_time(time)
      return "—" if time.nil?

      time.in_time_zone(SolidCableWeb.config.time_zone).strftime("%Y-%m-%d %H:%M:%S")
    end
  end
end
