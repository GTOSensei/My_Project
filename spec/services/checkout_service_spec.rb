# frozen_string_literal: true

RSpec.describe CheckoutService do
  let(:user) { create(:user, :with_addresses) }
  let(:order) { create(:order, user: user) }

  describe '#create_address' do
    let(:params) do
      ActionController::Parameters.new(order: {
                                         billing_address: user.billing_address.attributes,
                                         shipping_address: user.shipping_address.attributes
                                       })
    end

    context 'valid address parameters' do
      before { @result = CheckoutService.new(user, order, params, 'address').call }
      it 'returns true, if address create' do
        expect(@result).to be true
      end
      it 'returns true, if address valid' do
        expect(order.billing_address.valid?).to be true
        expect(order.shipping_address.valid?).to be true
      end
    end
    context 'not valid address parameters' do
      before do
        params[:order][:billing_address]['zip'] = 'invalid zip'
        params[:order][:shipping_address]['lastname'] = '555'
        @result = CheckoutService.new(user, order, params, 'address').call
      end
      it 'returns false, if address not create' do
        expect(@result).to be false
      end
      it 'returns false, if address not valid' do
        expect(order.billing_address.valid?).to be false
        expect(order.shipping_address.valid?).to be false
      end
    end
  end

  describe '#create_delivery' do
    let(:delivery) { create(:delivery) }
    let(:params) { { order: { delivery_id: delivery.id, order_id: order.id } } }

    context 'valid delivery' do
      before { @result = CheckoutService.new(user, order, params, 'delivery').call }
      it 'returns true, if delivery is selected' do
        expect(@result).to be true
      end
      it 'returns true, if the order with delivery' do
        expect(order.delivery.present?).to be true
      end
    end
    context 'not valid delivery' do
      before do
        params[:order][:delivery_id] = nil
        @result = CheckoutService.new(user, order, params, 'delivery').call
      end
      it 'returns true, if order without delivery' do
        expect(order.delivery.blank?).to be true
      end
      it 'returns false, if delivery is not selected' do
        expect(@result).to be false
      end
    end
  end

  describe '#create_payment' do
    let(:params) { ActionController::Parameters.new(order: { credit_card: attributes_for(:credit_card) }) }

    context 'valid credit_card' do
      before { @result = CheckoutService.new(user, order, params, 'payment').call }
      it 'returns true if credit_card is added' do
        expect(@result).to be true
      end
      it 'returns true, if credit_card valid' do
        expect(order.credit_card.valid?).to be true
      end
    end

    context 'not valid credit_card' do
      before do
        params[:order][:credit_card]['expiry_date'] = 'invalid date'
        @result = CheckoutService.new(user, order, params, 'payment').call
      end
      it 'returns false, if credit_card is not added' do
        expect(@result).to be false
      end
      it 'returns false, if credit_card not valid' do
        expect(order.credit_card.valid?).to be false
      end
    end
  end

  describe '#create_confirm' do
    let(:order) { create(:order, :with_associations).decorate }

    it 'returns true, if order confirm' do
      expect(CheckoutService.new(user, order, {}, 'confirm').call).to be true
    end
  end

  describe '#use_billing?' do
    it 'returns true, if use_billing checked' do
      params = { order: { use_billing: '1' } }
      expect(CheckoutService.new(user, order, params, nil).send(:use_billing?)).to be true
    end

    it 'returns false, if use_billing not checked' do
      params = { order: { use_billing: '' } }
      expect(CheckoutService.new(user, order, params, nil).send(:use_billing?)).to be false
    end
  end

  describe '#address_type' do
    it "returns 'billing_address'" do
      params = { order: { use_billing: '1' } }
      expect(CheckoutService.new(user, order, params, nil).send(:address_type)).to eq('billing_address')
    end

    it "returns 'shipping_address'" do
      params = { order: { use_billing: '' } }
      expect(CheckoutService.new(user, order, params, nil).send(:address_type)).to eq('shipping_address')
    end
  end
end
