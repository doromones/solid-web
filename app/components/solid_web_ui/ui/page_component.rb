# frozen_string_literal: true

module SolidWebUi
  module Ui
    # Page chrome shared by every dashboard screen: a title, an optional nav bar
    # (array of { label:, href:, active: }) and the page body as content.
    #
    # When +refresh+ is on (the default), the body is wrapped in a turbo-frame and
    # the header gains the live auto-refresh controls; the bundled JS reloads that
    # frame on the chosen interval. Pass refresh: false for a static page.
    class PageComponent < ViewComponent::Base
      FRAME_ID = "swui-refresh-frame"

      def initialize(title:, nav: [], refresh: true)
        @title = title
        @nav = nav || []
        @refresh = refresh
      end

      private

      attr_reader :title, :nav

      def refresh? = @refresh

      def nav_link_class(item)
        [ "swui-nav__link", item[:active] ? "swui-nav__link--active" : nil ].compact.join(" ")
      end
    end
  end
end
