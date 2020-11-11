# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook]
  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_one :billing_address, class_name: BillingAddress.name, as: :addressable, dependent: :destroy
  has_one :shipping_address, class_name: ShippingAddress.name, as: :addressable, dependent: :destroy
  has_one_attached :avatar

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: email_regexp },
                    length: { maximum: 63 }

  validates :password, presence: { if: :password_required? },
                       confirmation: { if: :password_required? },
                       length: { within: password_length, if: :password_required? }

  def password_required?
    !persisted? || password.present? || password_confirmation.present?
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      if user.save
        address = BillingAddress.new(addressable_type: User, addressable_id: user.id, \
                                     firstname: auth.info.first_name, lastname: auth.info.last_name)
        address.skip_facebook_validation = true
        address.save
        file = URI.parse(auth.info.image).open
        user.avatar.attach(io: file, filename: "facebook.#{file.content_type_parse.first.split('/').last}", \
                           content_type: file.content_type_parse.first)
      end
    end
  end
end
