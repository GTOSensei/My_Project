# frozen_string_literal: true

class OrderItemsController < ApplicationController
  before_action :order_item_service, only: %i[update destroy]

  def create
    if current_order.blank?
      order = CreateOrderService.new(current_user).call
      session[:order_id] = order.id unless user_signed_in?
    end
    order_item_service
  end

  def update; end

  def destroy; end

  private

  def order_item_service
    @result = OrderItemService.new(current_order, params).call
  end
end
