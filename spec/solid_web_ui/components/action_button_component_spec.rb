# frozen_string_literal: true

require "rails_helper"

RSpec.describe SolidWebUi::Ui::ActionButtonComponent, type: :component do
  it "renders a button_to form that targets the top frame" do
    render_inline(described_class.new(label: "Retry", url: "/retry"))

    expect(page).to have_css("form[action='/retry'][data-turbo-frame='_top']")
    expect(page).to have_css("button.swui-btn", text: "Retry")
  end

  it "supports a non-post HTTP method" do
    render_inline(described_class.new(label: "Discard", url: "/discard", method: :delete))

    expect(page).to have_css("input[name='_method'][value='delete']", visible: :all)
  end

  it "applies danger styling and a confirmation dialog" do
    render_inline(described_class.new(label: "Clear", url: "/clear", danger: true, confirm: "Sure?"))

    expect(page).to have_css("button.swui-btn.swui-btn--danger", text: "Clear")
    expect(page).to have_css("form[data-turbo-confirm='Sure?']")
  end

  it "omits the confirm attribute when none is given" do
    render_inline(described_class.new(label: "Pause", url: "/pause"))

    expect(page).to have_no_css("form[data-turbo-confirm]")
  end
end
