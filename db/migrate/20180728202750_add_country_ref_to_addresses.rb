# frozen_string_literal: true

class AddCountryRefToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_reference :addresses, :country, foreign_key: true
  end
end
