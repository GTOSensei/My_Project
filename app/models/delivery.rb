# frozen_string_literal: true

class Delivery < ApplicationRecord
  serialize :terms
  has_many :orders, dependent: :nullify

  REGEX_NAME = /\A[a-zA-Z]+( [a-zA-Z-]+)*\Z/.freeze
  REGEX_TERMS = /\A[a-zA-Z0-9]+( [a-zA-Z0-9-]+)*\Z/.freeze

  validates :name, format: { with: REGEX_NAME, message: I18n.t('errors.delivery') }
  validates :terms, format: { with: REGEX_TERMS, message: I18n.t('errors.terms') }
  validates :price, numericality: { greater_than_or_equal_to: 0.00, message: I18n.t('errors.price') }
end
