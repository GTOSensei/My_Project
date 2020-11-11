# frozen_string_literal: true

RSpec.describe OrderDecorator do
  let(:order) { create(:order).decorate }

  describe '#subtotal' do
    it 'returns subtotal' do
      expect(order.subtotal).to eq(order.order_items.sum(&:sub_total))
    end
  end

  describe '#total_count' do
    it 'returns total_count' do
      expect(order.total_count).to eq(order.order_items.sum(&:quantity))
    end
  end

  describe '#order_total' do
    it 'returns order_total' do
      result = order.subtotal - order.discount + order.delivery_price
      expect(order.order_total).to eq(result)
    end
  end

  describe '#discount' do
    it 'returns discount' do
      expect(order.discount).to eq(0.00.to_f)
    end
  end

  describe '#delivery_price' do
    it 'returns shipping amount' do
      expect(order.delivery_price).to eq(0.00.to_f)
    end
  end

  describe '#completed' do
    it "returns date in format '%Y-%m-%d'" do
      expect(order.completed).to eq(order.updated_at.strftime('%Y-%m-%d'))
    end
  end

  describe '#address_errors' do
    it 'returns nil if the address is valid' do
      expect(order.address_errors('billing_address')).to eq(nil)
    end

    it 'returns errors if the address is invalid' do
      order.create_billing_address(firstname: 'Alex', lastname: 'Doe', address: 'Dp', city: 'Dp', zip: '49000')
      expect(order.address_errors('billing_address')).to eq("Phone can't be blank, Phone is invalid")
    end
  end
end
