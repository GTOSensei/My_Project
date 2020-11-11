# frozen_string_literal: true

class ErrorsService
  include AddressConst

  def initialize(order, step)
    @order = order
    @step = step
  end

  def call
    send("error_#{@step}".to_sym)
  end

  private

  def error_address
    billing = I18n.t('address.billing_error') + @order.address_errors(BILLING)
    shipping = I18n.t('address.shipping_error') + @order.address_errors(SHIPPING)
    @order.use_billing ? billing : "#{billing}  <<<>>>  #{shipping}"
  end

  def error_delivery
    I18n.t('delivery.error')
  end

  def error_payment
    @order.credit_card.errors.full_messages.join(', ')
  end

  def error_confirm
    I18n.t('confirm.error')
  end
end
