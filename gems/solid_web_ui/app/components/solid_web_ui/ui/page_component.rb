# frozen_string_literal: true

module SolidWebUi
  module Ui
    # Page chrome shared by every dashboard screen: a title, an optional nav bar
    # (array of { label:, href:, active: }) and the page body as content.
    class PageComponent < ViewComponent::Base
      def initialize(title:, nav: [])
        @title = title
        @nav = nav || []
      end

      private

      attr_reader :title, :nav

      def nav_link_class(item)
        [ "swui-nav__link", item[:active] ? "swui-nav__link--active" : nil ].compact.join(" ")
      end
    end
  end
end
