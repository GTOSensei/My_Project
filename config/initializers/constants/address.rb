# frozen_string_literal: true

module AddressConst
  BILLING = 'billing_address'
  SHIPPING = 'shipping_address'
end

module RegexAddress
  TEXT_FIELDS = /\A(([a-zA-Z]+)([-\,'\s]?)([a-zA-Z]+))+\z/.freeze
  PHONE = /\A\+\d{10,14}\z/.freeze
  ZIP = /\A((\d)[-]?){1,10}\z/.freeze
  ADDRESS = /\A(([a-zA-Z0-9]+)([-\,'\s]?)([a-zA-Z0-9]+))+\z/.freeze
  MAX_LENGTH = 50
end
