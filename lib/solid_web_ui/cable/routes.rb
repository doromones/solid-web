# frozen_string_literal: true

SolidWebUi::Cable::Engine.routes.draw do
  root to: "dashboard#index"
  get "channels", to: "channels#index", as: :channels
  delete "messages/trim", to: "messages#trim", as: :trim_messages
end
