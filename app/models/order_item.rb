# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :book, counter_cache: true
  belongs_to :order

  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :price, :sub_total, numericality: { greater_than_or_equal_to: 0.01 }

  scope :id_asc, -> { order(id: :asc) }
end
