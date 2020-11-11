# frozen_string_literal: true

class OrderItemService
  def initialize(order, params)
    @order = order
    @action = params[:action] || 'create'
    @order_item_decorator = OrderItemDecorator.new(order, params)
  end

  def call
    send(@action.to_sym)
  end

  private

  def create
    return update if order_item.present?

    @order.order_items.new(order_item_params).save
  end

  def update
    order_item.update(order_item_params)
  end

  def destroy
    order_item.destroy
    @order.destroy if @order.order_items.blank?
  end

  def order_item
    @order_item_decorator.order_item
  end

  def order_item_params
    {
      book: @order_item_decorator.book,
      price: @order_item_decorator.price,
      quantity: @order_item_decorator.quantity,
      sub_total: @order_item_decorator.sub_total
    }
  end
end
