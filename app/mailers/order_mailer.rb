# frozen_string_literal: true

class OrderMailer < ApplicationMailer
  default from: 'from@bookstore.com'

  def info_about_order(user, order)
    @user = user
    @order = order
    mail(to: @user.email, subject: I18n.t('info.mail_thanks'))
  end
end
