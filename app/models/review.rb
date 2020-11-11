# frozen_string_literal: true

class Review < ApplicationRecord
  include RegexReview
  belongs_to :book
  belongs_to :user
  enum status: { unprocessed: 0, approved: 1, rejected: 2 }

  scope :unprocessed, -> { where(status: :unprocessed) }
  scope :others_status, -> { where(status: %i[approved rejected]) }

  validates :status, presence: true
  validates :rating, length: { is: 1 }, numericality: { only_integer: true, \
                                                        greater_than_or_equal_to: MIN_RATE, \
                                                        less_than_or_equal_to: MAX_RATE }
  validates :title, length: { maximum: MAX_TITLE }, format: { with: TEXT }, presence: true
  validates :comment, length: { maximum: MAX_COMMENT }, format: { with: TEXT }, presence: true
  validates :status, presence: true, inclusion: { in: statuses }
end
