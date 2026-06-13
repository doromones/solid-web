# frozen_string_literal: true

module SolidWebUi
  module Ui
    # Renders pagination controls for a SolidWebUi::Paginator. `page_url` is a
    # callable mapping a page number to a URL (so the component stays decoupled
    # from any engine's routes). Hidden entirely when there is only one page.
    class PaginatorComponent < ViewComponent::Base
      def initialize(paginator:, page_url:)
        @paginator = paginator
        @page_url = page_url
      end

      def render?
        @paginator.total_pages > 1
      end

      private

      attr_reader :paginator, :page_url
    end
  end
end
