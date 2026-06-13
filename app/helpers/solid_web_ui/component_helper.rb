# frozen_string_literal: true

module SolidWebUi
  # Thin view helpers wrapping the shared Ui::* ViewComponents, so engine views
  # read `swui_page(...)` instead of `render SolidWebUi::Ui::PageComponent.new(...)`.
  # Included into each engine's controller via `helper SolidWebUi::ComponentHelper`.
  module ComponentHelper
    def swui_page(title:, nav: [], &block)
      render(Ui::PageComponent.new(title: title, nav: nav), &block)
    end

    def swui_stat_card(label:, value:, tone: :neutral, href: nil)
      render(Ui::StatCardComponent.new(label: label, value: value, tone: tone, href: href))
    end

    def swui_status_badge(label:, status: nil)
      render(Ui::StatusBadgeComponent.new(label: label, status: status))
    end

    def swui_table(headers:, empty_message: "Nothing to show.", &block)
      render(Ui::TableComponent.new(headers: headers, empty_message: empty_message), &block)
    end

    def swui_paginator(paginator:, page_url:)
      render(Ui::PaginatorComponent.new(paginator: paginator, page_url: page_url))
    end
  end
end
