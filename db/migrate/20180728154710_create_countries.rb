# frozen_string_literal: true

class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :countries do |t|
      t.string :name, index: { unique: true }
      t.string :phone_code, index: { unique: true }

      t.timestamps
    end
  end
end
