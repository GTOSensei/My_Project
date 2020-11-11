# frozen_string_literal: true

class AddCouponRefToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :coupon, foreign_key: true
  end
end
