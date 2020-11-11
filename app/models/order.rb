# frozen_string_literal: true

class Order < ApplicationRecord
  include OrderConst
  belongs_to :user, optional: true
  belongs_to :delivery, optional: true
  belongs_to :coupon, optional: true
  has_many :order_items, dependent: :destroy
  has_one :credit_card, dependent: :destroy
  has_one :billing_address, class_name: BillingAddress.name, as: :addressable, dependent: :destroy
  has_one :shipping_address, class_name: ShippingAddress.name, as: :addressable, dependent: :destroy
  enum status: { IN_PROGRESS => 0, IN_QUEUE => 1, IN_DELIVEY => 2, DELIVERED => 3, CANCELED => 4 }

  validates :total_price, numericality: { greater_than_or_equal_to: 0.00 }
  validates :order_number, uniqueness: { case_sensitive: false }
  validates :status, presence: true, inclusion: { in: statuses }

  attr_accessor :use_billing

  scope :in_progress, -> { where(status: IN_PROGRESS).order(created_at: :desc) }
  scope :in_queue, -> { where(status: IN_QUEUE).order(created_at: :desc) }
  scope :in_delivery, -> { where(status: IN_DELIVEY).order(created_at: :desc) }
  scope :delivered, -> { where(status: DELIVERED).order(created_at: :desc) }
  scope :canceled, -> { where(status: CANCELED).order(created_at: :desc) }
  scope :accepted, -> { where.not(status: IN_PROGRESS).order(created_at: :desc) }
  scope :not_completed, -> { where.not(status: %I[#{DELIVERED} #{CANCELED}]).order(created_at: :desc) }
end
