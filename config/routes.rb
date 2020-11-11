# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  scope '(:locale)', locale: Regexp.new(I18n.available_locales.join('|')) do
    root to: 'home#index'
    resources :books, only: %i[index show]
    resources :books do
      resources :reviews, only: [:create]
    end
    resources :orders, only: %i[index show]
    resource :cart, only: %i[show update]
    resources :order_items, only: %i[create update destroy]
    resources :checkouts
    devise_for :users, skip: :omniauth_callbacks, controllers: { registrations: 'registrations' }
    ActiveAdmin.routes(self)
  end
end
