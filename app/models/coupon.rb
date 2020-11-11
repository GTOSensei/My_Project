# frozen_string_literal: true

class Coupon < ApplicationRecord
  has_many :orders, dependent: :destroy

  REGEX_CODE = /\A[A-Z0-9]+(-[A-Z0-9]+)*\Z/.freeze

  validates :code, format: { with: REGEX_CODE, message: I18n.t('errors.code') }
  validates :discount, numericality: { only_integer: true, message: I18n.t('errors.discount') }
end
