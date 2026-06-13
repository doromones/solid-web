# frozen_string_literal: true

require "rails_helper"

RSpec.describe SolidWebUi::Ui::PageComponent, type: :component do
  it "renders the page title and content" do
    render_inline(described_class.new(title: "Dashboard")) { "body content" }

    expect(page).to have_css(".swui-page")
    expect(page).to have_css(".swui-page__title", text: "Dashboard")
    expect(page).to have_text("body content")
  end

  it "renders nav items when provided" do
    nav = [ { label: "Jobs", href: "/jobs", active: true }, { label: "Queues", href: "/queues" } ]
    render_inline(described_class.new(title: "X", nav: nav))

    expect(page).to have_css("a.swui-nav__link[href='/jobs'].swui-nav__link--active", text: "Jobs")
    expect(page).to have_css("a.swui-nav__link[href='/queues']", text: "Queues")
  end

  it "wraps the body in a refreshable turbo-frame and shows the controls by default" do
    render_inline(described_class.new(title: "Dashboard")) { "body content" }

    expect(page).to have_css("turbo-frame#swui-refresh-frame[refresh='morph'][data-turbo-action='advance']", text: "body content")
    expect(page).to have_css(".swui-refresh select[data-swui-refresh-select]")
  end

  it "omits the frame and controls when refresh is disabled" do
    render_inline(described_class.new(title: "Static", refresh: false)) { "body content" }

    expect(page).to have_text("body content")
    expect(page).to have_no_css("turbo-frame")
    expect(page).to have_no_css(".swui-refresh")
  end
end
