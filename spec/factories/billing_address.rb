# frozen_string_literal: true

FactoryBot.define do
  factory :billing_address, class: 'BillingAddress' do
    firstname { FFaker::Name.first_name }
    lastname { FFaker::Name.last_name }
    address { FFaker::Address.street_name }
    city { FFaker::Address.city }
    zip { FFaker::AddressUA.zip_code }
    country
    phone { "#{country.phone_code}123456789" }
    country_id { country.id }
  end
end
