# frozen_string_literal: true

class OrderMergerService
  def initialize(user, find_user_order, find_by_session)
    @user = user
    @user_order = find_user_order
    @session_order = find_by_session
  end

  def call
    @user_order.blank? ? assign_order_to_user : unite_orders
  end

  private

  def assign_order_to_user
    @session_order.update(user: @user)
    @session_order
  end

  def unite_orders
    @session_order.order_items.each do |item|
      params = ActionController::Parameters.new(order_item_attributes(item))
      OrderItemService.new(@user_order, params).call
    end
    @session_order.destroy
    @user_order
  end

  def order_item_attributes(order_item)
    order_item.attributes.select do |key, _value|
      %w[book_id price quantity sub_total].include?(key)
    end
  end
end
