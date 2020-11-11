# frozen_string_literal: true

class QuikRegisterMailer < ApplicationMailer
  default from: 'from@bookstore.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: I18n.t('info.mail_welcome'))
  end
end
