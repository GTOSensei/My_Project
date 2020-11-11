# frozen_string_literal: true

module CheckoutsHelper
  def errors_card?(key)
    @order.credit_card&.errors&.include?(key)
  end

  def error(key)
    @order.credit_card.errors[key].join(', ') if @order.credit_card
  end

  def mask_card
    return if @order.credit_card.blank?

    "** ** ** #{@order.credit_card.number}"
  end
end
