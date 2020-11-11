# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.string :title
      t.text :comment
      t.integer :rating
      t.integer :status, null: false, default: 0
      t.belongs_to :book, foreign_key: true

      t.timestamps
    end
  end
end
