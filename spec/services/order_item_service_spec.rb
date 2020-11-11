# frozen_string_literal: true

RSpec.describe OrderItemService do
  let(:order) { create(:order) }

  describe '#create' do
    let(:book) { create(:book) }
    let(:params) { ActionController::Parameters.new(book_id: book.id, quantity: 1, action: :create) }
    before { @result = OrderItemService.new(order, params).call }

    it 'returns true, if book is added to order' do
      expect(@result).to be true
    end

    it 'checks whether quantity is equal 1' do
      expect(order.order_items.find_by(book: book).quantity).to eq(1)
    end

    it 'checks if the order contains a book' do
      expect(order.order_items.find_by(book: book).book).to eq(book)
    end

    context 'checks for duplicates and increased quantity book' do
      before { OrderItemService.new(order, params).call }

      it 'adding the same book it is not duplicated' do
        expect(order.order_items.where(book: book).count).to eq(1)
      end

      it 'adding the same book, quantity increases' do
        expect(order.order_items.find_by(book: book).quantity).to eq(2)
      end
    end

    context 'returns method create if action: nil' do
      let(:new_book) { create(:book) }
      let(:parameters) { ActionController::Parameters.new(book_id: new_book.id, quantity: 3) }
      before { @result = OrderItemService.new(order, parameters).call }

      it 'returns true, if book is added to order' do
        expect(@result).to be true
      end

      it 'checks if the order contains a new_book' do
        expect(order.order_items.find_by(book: new_book).book).to eq(new_book)
      end

      it 'checks whether quantity is equal 3' do
        expect(order.order_items.find_by(book: new_book).quantity).to eq(3)
      end
    end
  end

  describe '#update' do
    let(:order_item) { order.order_items.first }
    let(:quantity) { order_item.quantity + 1 }
    let(:params) { ActionController::Parameters.new(quantity: quantity, id: order_item.id, action: :update) }
    before { @result = OrderItemService.new(order, params).call }

    it 'returns true if quantity of books is updated' do
      expect(@result).to be true
    end

    it 'checks whether quantity of books has changed' do
      order_item.reload
      expect(order_item.quantity).to eq(quantity)
    end

    it 'checks for duplicate books' do
      order.reload
      order.order_items.each do |item|
        expect(order.order_items.where(book: item.book).count).to eq(1)
      end
    end
  end

  describe '#destroy' do
    let(:order_item) { order.order_items.last }
    let(:params) { ActionController::Parameters.new(id: order_item.id, action: :destroy) }
    before { @result = OrderItemService.new(order, params).call }

    it '@result returns nil if order_item has been deleted' do
      expect(@result).to eq(nil)
    end

    it 'order_items does not contain order_item after deletion' do
      expect(order.order_items.find_by(id: order_item.id)).to eq(nil)
    end

    it 'destroy order if order_items is nil' do
      order.order_items.each do |item|
        OrderItemService.new(order, ActionController::Parameters.new(id: item.id, action: :destroy)).call
        expect(order.order_items.find_by(id: item.id)).to eq(nil)
        begin
          order.reload
        rescue StandardError
          nil
        end
      end
      expect(Order.find_by(id: order.id)).to eq(nil)
    end
  end
end
