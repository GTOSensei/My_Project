# frozen_string_literal: true

class ReviewDecorator < Draper::Decorator
  include AddressConst
  delegate_all

  def logo
    object.user.avatar if object.user.avatar.attached?
  end

  def name
    full_name(BILLING) || full_name(SHIPPING) || email
  end

  def date
    object.created_at.strftime('%Y/%m/%d')
  end

  def self.errors(review, key)
    return false if review.blank?

    review.errors[key].present?
  end

  private

  def email
    index = object.user.email.index('@')
    object.user.email[0, index].capitalize
  end

  def full_name(type)
    return if object.user.send(type).blank?

    object.user.send(type).firstname + ' ' + object.user.send(type).lastname
  end
end
