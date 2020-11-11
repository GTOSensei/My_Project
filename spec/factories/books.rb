# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { FFaker::Book.unique.title }
    description { FFaker::Book.description }
    price { rand(3.5..100).round(2) }
    quantity { rand(1..100) }
    materials { FFaker::Color.name }
    height { rand(0.1..6).round(2) }
    width { rand(0.1..4).round(2) }
    depth { rand(0.1..2).round(2) }
    dimensions { { height: height, width: width, depth: depth } }
    published_at { rand(1995..2018) }
    after(:create) do |book|
      create_list(:author, 2, books: [book])
    end
    after(:create) do |book|
      create_list(:review, 2, book: book)
    end
  end
end
