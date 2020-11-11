# frozen_string_literal: true

class FindOrderService
  def initialize(user, order_id = '')
    @user = user
    @order_id = order_id
  end

  def call
    found_order.try(:decorate)
  end

  private

  def found_order
    @user.present? ? find_user_order : find_by_session
  end

  def find_by_session
    return if @order_id.blank?

    @find_by_session ||= Order.in_progress.find_by(id: @order_id)
  end

  def find_user_order
    @find_user_order ||= @user.orders.in_progress.first
    return @find_user_order if find_by_session.blank?

    OrderMergerService.new(@user, @find_user_order, @find_by_session).call
  end
end
