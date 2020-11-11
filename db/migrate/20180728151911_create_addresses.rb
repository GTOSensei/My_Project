# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :firstname
      t.string :lastname
      t.string :address
      t.string :city
      t.string :zip
      t.string :phone
      t.string :type
      t.belongs_to :addressable, polymorphic: true

      t.timestamps
    end
    add_index :addresses, %i[addressable_id addressable_type]
  end
end
