# frozen_string_literal: true

RSpec.describe OrderMergerService do
  let(:user) { create(:user) }
  let(:user_order) { create(:order, user: user) }
  let(:session_order) { create(:order) }

  context 'merging orders session_order with user_order' do
    let!(:order_merge) { OrderMergerService.new(user, user_order, session_order).call }

    it 'order_items orders are merged' do
      expect(order_merge.order_items).to eq(user_order.order_items)
    end
    it 'destroy session_order if orders are united' do
      begin
        session_order.reload
      rescue StandardError
        nil
      end
      expect(Order.find_by(id: session_order.id)).to eq(nil)
    end
  end

  context 'merging session_order with user' do
    let(:order_merge) { OrderMergerService.new(user, nil, session_order).call }

    it 'order_items belongs to a user order' do
      expect(order_merge.order_items).to eq(session_order.order_items)
    end

    it 'session_order belongs to user' do
      expect(order_merge.user).to eq(session_order.user)
    end
  end
end
