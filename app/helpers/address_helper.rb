# frozen_string_literal: true

module AddressHelper
  def error_address?(key, address)
    address&.errors&.include?(key)
  end

  def error_key(key, address)
    address.errors[key].join(', ') if address
  end

  def order_billing
    (@order.billing_address.blank? ? @user : @order).billing_address
  end

  def order_shipping
    (@order.shipping_address.blank? ? @user : @order).shipping_address
  end
end
