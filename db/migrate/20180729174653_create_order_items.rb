# frozen_string_literal: true

class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.decimal :price, precision: 8, scale: 2, null: false, default: 0.00
      t.integer :quantity, null: false, default: 0
      t.decimal :sub_total, precision: 8, scale: 2, null: false, default: 0.00
      t.belongs_to :book, index: true
      t.belongs_to :order, index: true

      t.timestamps
    end
  end
end
