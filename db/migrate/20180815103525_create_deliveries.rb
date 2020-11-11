# frozen_string_literal: true

class CreateDeliveries < ActiveRecord::Migration[5.2]
  def change
    create_table :deliveries do |t|
      t.string :name
      t.text :terms
      t.decimal :price, precision: 6, scale: 2

      t.timestamps
    end
  end
end
