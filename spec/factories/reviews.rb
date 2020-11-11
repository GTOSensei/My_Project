# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    user
    book
    title { FFaker::Job.title }
    comment { FFaker::Lorem.sentence(5) }
    rating { rand(1..5) }
    status { :approved }
  end
end
