# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :order_number, index: { unique: true }
      t.decimal :total_price, precision: 10, scale: 2, null: false, default: 0.00
      t.integer :status, null: false, default: 0
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
