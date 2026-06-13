# frozen_string_literal: true

require "rails_helper"

RSpec.describe SolidWebUi::HeadHelper, type: :helper do
  it "emits the bundled stylesheet and the scoped theme tokens" do
    html = helper.solid_web_ui_head_tags

    expect(html).to include("solid_web_ui")          # stylesheet link
    expect(html).to include(".solid-web-ui")         # token scope
    expect(html).to include("--swui-color-primary")  # a design token
  end
end
