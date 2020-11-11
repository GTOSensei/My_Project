# frozen_string_literal: true

class AddressService
  include AddressConst

  def initialize(resource, params, type)
    @resource = resource
    @address_params = params
    @type = type
  end

  def call
    return false unless type_address.key?(@type)

    address.blank? ? create_address : address_update
  end

  private

  def address_update
    address.update(@address_params)
  end

  def create_address
    type_address[@type].call.valid?
  end

  def type_address
    {
      BILLING => -> { @resource.create_billing_address(@address_params) },
      SHIPPING => -> { @resource.create_shipping_address(@address_params) }
    }
  end

  def address
    @resource.send(@type.to_sym)
  end
end
