# frozen_string_literal: true

RSpec.describe CreateOrderService do
  context 'create order for authorized user' do
    let(:user) { create(:user) }
    let!(:order) { CreateOrderService.new(user).call }

    it 'returns created order' do
      expect(user.orders.first).to eq(order)
    end

    it 'created order does belong to user' do
      expect(order.user).to eq(user)
    end
  end

  context 'create order for unauthorized user' do
    let(:order) { CreateOrderService.new(nil).call }

    it 'created order does not belong to user' do
      expect(order.user).to be_nil
    end

    it 'created order is not empty' do
      expect(order).not_to be_nil
    end

    it "order number begins 'R'" do
      expect(order.order_number[0]).to eq('R')
    end

    it 'returns true if the order is valid' do
      expect(order.valid?).to be true
    end
  end
end
