# frozen_string_literal: true

class CreditCard < ApplicationRecord
  include RegexPayment
  belongs_to :order

  attr_accessor :cvv

  validates :number, format: { with: NUMBER }, presence: true
  validates :card_owner, length: { maximum: MAX }, format: { with: CARD_OWNER }, presence: true
  validates :expiry_date, format: { with: EXPIRY_DATE, message: I18n.t('errors.expiry_date') }, presence: true
end
