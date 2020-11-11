# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    title { FFaker::Book.unique.genre }
    after(:create) do |category|
      create_list(:book, 5, categories: [category])
    end
  end
end
