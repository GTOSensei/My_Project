# frozen_string_literal: true

class QuikRegisterService
  def initialize(email)
    @email = email
  end

  def call
    return if user_found?

    user = User.new(email: @email, password: Devise.friendly_token(10))
    send_email(user) if user.save
    user
  end

  private

  def user_found?
    User.find_by(email: @email).present?
  end

  def send_email(user)
    QuikRegisterMailer.welcome_email(user).deliver_now
  end
end
