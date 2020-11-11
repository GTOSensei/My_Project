# frozen_string_literal: true

class OrderDecorator < Draper::Decorator
  delegate_all
  ZERO_PRICE = 0.00.to_f

  def subtotal
    order_items.sum(&:sub_total)
  end

  def total_count
    order_items.sum(&:quantity)
  end

  def order_total
    return delivery_price if discount > subtotal

    subtotal - discount + delivery_price
  end

  def discount
    coupon.blank? ? ZERO_PRICE : coupon.discount.to_f
  end

  def delivery_price
    delivery.blank? ? ZERO_PRICE : delivery.price.to_f
  end

  def completed
    updated_at.strftime('%Y-%m-%d')
  end

  def address_errors(type)
    return if send(type.to_sym).blank?

    send(type.to_sym).errors.full_messages.join(', ')
  end
end
