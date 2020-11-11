# frozen_string_literal: true

RSpec.describe OrderMailer, type: :mailer do
  describe 'OrderMailer' do
    let(:order) { create(:order, :with_associations) }
    let(:user) { order.user }
    let(:mail) { OrderMailer.info_about_order(user, order) }

    it 'renders the headers' do
      expect(mail.subject).to eq(I18n.t('info.mail_thanks'))
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@bookstore.com'])
    end

    it 'renders the body' do
      ["#{I18n.t('info.order_number')} #{order.order_number}, #{I18n.t('info.worth')} #{order.total_price}",
       "#{I18n.t('info.delivery')} #{order.delivery.name}",
       "#{I18n.t('info.delivery_time')} #{order.delivery.terms}"].each do |txt|
        expect(mail.body.encoded).to match(txt)
      end
    end
  end
end
