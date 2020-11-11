# frozen_string_literal: true

class OrderItemDecorator < Draper::Decorator
  delegate_all

  def initialize(order, params)
    @order = order
    @params = params
  end

  def order_item
    @order_item ||= @order.order_items.find_by(@params.permit(:book_id, :id))
  end

  def sub_total
    price * quantity
  end

  def price
    order_item.blank? ? book.price : order_item.price
  end

  def quantity
    return add_quantity if order_item.present? && @params[:book_id].present?

    @params[:quantity].to_i
  end

  def add_quantity
    order_item.quantity + @params[:quantity].to_i
  end

  def book
    return order_item.book if order_item.present?

    @book ||= Book.find_by(id: @params[:book_id])
  end
end
