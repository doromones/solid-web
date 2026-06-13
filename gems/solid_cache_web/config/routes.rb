# frozen_string_literal: true

SolidCacheWeb::Engine.routes.draw do
  root to: "dashboard#index"
  get "entries", to: "entries#index", as: :entries
  delete "entries", to: "entries#clear", as: :clear_entries
end
