# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "admin#{i}@amazing.com" }
    password { FFaker::Internet.password }

    trait :with_addresses do
      after(:create) do |user|
        create(:billing_address, addressable: user)
        create(:shipping_address, addressable: user)
      end
    end
  end
end
