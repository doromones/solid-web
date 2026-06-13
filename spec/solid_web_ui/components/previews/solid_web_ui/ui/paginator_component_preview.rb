# frozen_string_literal: true

module SolidWebUi
  module Ui
    # @label Paginator
    class PaginatorComponentPreview < ViewComponent::Preview
      # @param page number
      # @param total_count number
      def default(page: 3, total_count: 120)
        paginator = SolidWebUi::Paginator.new(total_count.to_i, page: page.to_i, per_page: 25)
        render(PaginatorComponent.new(paginator: paginator, page_url: ->(p) { "?page=#{p}" }))
      end
    end
  end
end
