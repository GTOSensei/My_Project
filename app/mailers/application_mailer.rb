# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'from@bookstore.com'
  layout 'mailer'
end
