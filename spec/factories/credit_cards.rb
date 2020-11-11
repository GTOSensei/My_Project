# frozen_string_literal: true

FactoryBot.define do
  factory :credit_card do
    number { rand(1000..9999).to_s }
    card_owner { FFaker::Lorem.word }
    expiry_date { '12/20' }
    order
  end
end
