# frozen_string_literal: true

RSpec.describe OrderItemDecorator do
  let(:order) { create(:order) }
  let(:order_item) { order.order_items.first }
  let(:book) { order_item.book }
  let(:params) { ActionController::Parameters.new(book_id: book.id, id: order_item.id, quantity: 1) }
  let(:order_item_decorator) { OrderItemDecorator.new(order, params) }

  describe '#order_item' do
    it 'returns order_item' do
      expect(order_item_decorator.order_item).to eq(order.order_items.find_by(params.permit(:book_id, :id)))
    end
  end

  describe '#sub_total' do
    it 'returns sub_total' do
      sub_total = order_item.price * (order_item.quantity + params[:quantity].to_i)
      expect(order_item_decorator.sub_total).to eq(sub_total)
    end
  end

  describe '#price' do
    it 'returns price' do
      expect(order_item_decorator.price).to eq(order_item.price)
    end
  end

  describe '#quantity' do
    it 'returns quantity' do
      quantity = order_item.quantity + params[:quantity].to_i
      expect(order_item_decorator.quantity).to eq(quantity)
    end
  end

  describe '#add_quantity' do
    it 'returns add_quantity' do
      quantity = order_item.quantity + params[:quantity].to_i
      expect(order_item_decorator.add_quantity).to eq(quantity)
    end
  end

  describe '#book' do
    it 'returns book' do
      expect(order_item_decorator.book).to eq(book)
    end
  end
end
