# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    order_number { "R#{Array.new(8) { [*'0'..'9'].sample }.join}" }
    user
    after(:create) do |order|
      create_list(:order_item, 4, order: order)
    end

    trait :with_associations do
      delivery
      after(:create) do |order|
        create(:credit_card, order: order)
        create(:billing_address, addressable: order)
        create(:shipping_address, addressable: order)
      end
    end
  end
end
