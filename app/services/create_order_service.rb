# frozen_string_literal: true

class CreateOrderService
  def initialize(user)
    @user = user
  end

  def call
    create_order.decorate
  end

  private

  def create_order
    order = @user.present? ? @user.orders.create(params) : Order.create(params)
    order.valid? ? order : create_order
  end

  def params
    { order_number: "R#{Array.new(8) { [*'0'..'9'].sample }.join}" }
  end
end
