# frozen_string_literal: true

class Address < ApplicationRecord
  include RegexAddress
  belongs_to :addressable, polymorphic: true
  belongs_to :country, optional: { unless: :skip_facebook_validation }

  validates :address, :zip, :phone, :firstname, :lastname, :city, presence: true, unless: :skip_facebook_validation
  validates :address, length: { maximum: MAX_LENGTH }, format: { with: ADDRESS }, unless: :skip_facebook_validation
  validates :zip, format: { with: ZIP }, unless: :skip_facebook_validation
  validates :phone, format: { with: PHONE }, unless: :skip_facebook_validation
  validates :firstname, :lastname, :city, length: { maximum: MAX_LENGTH },
                                          format: { with: TEXT_FIELDS }, unless: :skip_facebook_validation
  validate :validate_phone_code

  attr_accessor :skip_facebook_validation

  def validate_phone_code
    return if phone.blank?

    country = Country.find(country_id)
    return if phone.include?(country.phone_code)

    errors.add(:phone, I18n.t('errors.phone') + country.phone_code)
  end
end
