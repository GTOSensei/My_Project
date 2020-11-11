# frozen_string_literal: true

RSpec.describe QuikRegisterMailer, type: :mailer do
  describe 'QuikRegister' do
    let(:user) { create(:user) }
    let(:mail) { QuikRegisterMailer.welcome_email(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq(I18n.t('info.mail_welcome'))
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@bookstore.com'])
    end

    it 'renders the body' do
      [I18n.t('info.successfully_mail'),
       I18n.t('info.thanks_mailer'),
       "#{I18n.t('info.password')} #{user.password}"].each do |txt|
        expect(mail.body.encoded).to match(txt)
      end
    end
  end
end
