# frozen_string_literal: true

require "rails_helper"

RSpec.describe SolidWebUi::Ui::PaginatorComponent, type: :component do
  def paginator(page:)
    SolidWebUi::Paginator.new(120, page: page, per_page: 25)
  end

  it "does not render at all for a single page" do
    render_inline(described_class.new(paginator: SolidWebUi::Paginator.new(5, page: 1, per_page: 25),
                                      page_url: ->(p) { "?page=#{p}" }))
    expect(page).not_to have_css(".swui-pagination")
  end

  it "renders prev/next links pointing at the right pages" do
    render_inline(described_class.new(paginator: paginator(page: 3), page_url: ->(p) { "?page=#{p}" }))

    expect(page).to have_css(".swui-pagination")
    expect(page).to have_link(href: "?page=2") # prev
    expect(page).to have_link(href: "?page=4") # next
  end

  it "disables prev on the first page and next on the last" do
    render_inline(described_class.new(paginator: paginator(page: 1), page_url: ->(p) { "?page=#{p}" }))
    expect(page).to have_css(".swui-pagination__item--disabled", text: /prev/i)

    render_inline(described_class.new(paginator: paginator(page: 5), page_url: ->(p) { "?page=#{p}" }))
    expect(page).to have_css(".swui-pagination__item--disabled", text: /next/i)
  end
end
