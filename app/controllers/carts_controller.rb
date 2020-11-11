# frozen_string_literal: true

class CartsController < ApplicationController
  def update
    coupon = Coupon.find_by(code: params[:code])
    @coupon_applied = coupon.blank? ? false : current_order.update(coupon: coupon)
  end
end
