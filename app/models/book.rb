# frozen_string_literal: true

class Book < ApplicationRecord
  serialize :dimensions, Hash
  has_many :author_books, dependent: :destroy
  has_many :authors, through: :author_books
  has_many :reviews, dependent: :destroy
  has_many :book_categories, dependent: :destroy
  has_many :categories, through: :book_categories
  has_many :order_items, dependent: :destroy
  has_many_attached :images
  attr_accessor :height, :width, :depth
  validates :title, :dimensions, :description, :materials, presence: true
  validates :price, :height, :width, :depth, numericality: { greater_than_or_equal_to: 0.01 }
  validates :quantity, numericality: { only_integer: true }
  validates :published_at, numericality: { less_than_or_equal_to: Date.current.year }
  validates :images, file_size: { less_than_or_equal_to: 1.megabyte, message: I18n.t('errors.file_size') + '%{count}' },
                     file_content_type: { allow: ['image/jpeg', 'image/jpg', 'image/png'], \
                                          message: I18n.t('errors.file_content') }

  scope :books_category, ->(title) { joins(:categories).where('categories.title' => title) }
  scope :newest, -> { order(created_at: :desc) }
  scope :popular, -> { order(order_items_count: :desc, title: :asc) }
  scope :price_low_to_high, -> { order(price: :asc) }
  scope :price_high_to_low, -> { order(price: :desc) }
  scope :title_asc, -> { order(title: :asc) }
  scope :title_desc, -> { order(title: :desc) }
  scope :lattest_books, -> { order(created_at: :desc).limit(3) }

  def properties
    "H:#{dimensions[:height]}\" x W:#{dimensions[:width]}\" x D:#{dimensions[:depth]}\""
  end
end
