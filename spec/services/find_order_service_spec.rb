# frozen_string_literal: true

RSpec.describe FindOrderService do
  it 'returns nil if the order is not found' do
    expect(FindOrderService.new(nil, nil).call).to be_nil
  end

  it 'returns order from session' do
    order = create(:order)
    expect(FindOrderService.new(nil, order.id).call).to eq(order)
  end

  it 'returns nil if the user has not created an order' do
    expect(FindOrderService.new(create(:user), nil).call).to be_nil
  end

  it 'returns the order of the user' do
    order = create(:order)
    expect(FindOrderService.new(order.user, nil).call).to eq(order)
  end

  context 'merge user order and session order ' do
    let(:session_order) { create(:order) }
    let(:user) { create(:user) }
    let!(:user_order) { create(:order, user: user) }
    let!(:found_order) { FindOrderService.new(user, session_order.id).call }

    it 'returns merge order_items of the user with the session' do
      expect(found_order.order_items).to eq(user.orders.in_progress.first.order_items)
    end

    it 'returns merged order to user' do
      expect(found_order).to eq(user.orders.in_progress.first)
    end

    it 'returns total count order_items after merge' do
      expect(found_order.order_items.count).to eq(8)
    end

    it 'found order belongs to the same user' do
      expect(found_order.user).to eq(user)
    end
  end

  context 'order session is assigned to user' do
    let(:session_order) { create(:order) }
    let(:user) { create(:user) }
    let!(:found_order) { FindOrderService.new(user, session_order.id).call }

    it 'appends order_items to user' do
      expect(found_order.order_items).to eq(user.orders.in_progress.first.order_items)
    end

    it 'order session belongs to the user' do
      expect(user.orders.in_progress.first).to eq(session_order)
    end
  end
end
