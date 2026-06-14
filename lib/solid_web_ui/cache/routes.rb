# frozen_string_literal: true

SolidWebUi::Cache::Engine.routes.draw do
  root to: "dashboard#index"
  get "entries", to: "entries#index", as: :entries
  delete "entries", to: "entries#clear", as: :clear_entries
  get "entries/:id", to: "entries#show", as: :entry
end
