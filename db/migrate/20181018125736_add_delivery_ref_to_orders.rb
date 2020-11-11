# frozen_string_literal: true

class AddDeliveryRefToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :delivery, foreign_key: true
  end
end
