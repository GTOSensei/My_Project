# frozen_string_literal: true

RSpec.describe ErrorsService do
  let(:order) { create(:order).decorate }

  describe '#error_address' do
    before do
      country = create(:country)
      params = { firstname: 'Alex', lastname: 'Doe', address: 'Aliza Court', city: 'Dnipro',
                 zip: '49000', phone: "#{country.phone_code}123456789", country_id: country.id }
      order.create_shipping_address(params)
      order.use_billing = true
      params[:zip] = 'invalid zip code'
      order.create_billing_address(params)
    end
    it 'returns order address errors' do
      expect(ErrorsService.new(order, 'address').call).to eq('Billing Address Errors: Zip is invalid')
    end
  end

  describe '#error_delivery' do
    it 'returns order delivery errors' do
      expect(ErrorsService.new(order, 'delivery').call).to eq(I18n.t('delivery.error'))
    end
  end

  describe '#error_payment' do
    it 'returns order payment errors' do
      order.create_credit_card(number: 1232, card_owner: 'Alex Doe', expiry_date: '30/30')
      expect(ErrorsService.new(order, 'payment').call).to eq('Expiry date Expected format is MM/YY')
    end
  end

  describe '#error_confirm' do
    it 'returns order confirmation error' do
      expect(ErrorsService.new(order, 'confirm').call).to eq(I18n.t('confirm.error'))
    end
  end
end
