# frozen_string_literal: true

RSpec.describe OrderItemsController, type: :controller do
  describe 'POST #create' do
    let(:book) { create(:book) }
    let(:order) { CreateOrderService.new(nil).call }
    let(:params) { { book_id: book.id, quantity: 1, action: 'create' } }
    let(:result) { OrderItemService.new(order, ActionController::Parameters.new(params)).call }
    before do
      session[:order_id] = order.id
      post :create, xhr: true, params: params
    end

    it { is_expected.to use_before_action(:order_item_service) }
    it { is_expected.to set_session[:order_id] }
    it { is_expected.to set_session[:order_id].to(order.id) }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'checks the number of order_item' do
      expect(order.order_items.first.quantity).to eq(1)
    end

    it 'order is not nil' do
      expect(order).not_to be_nil
    end

    it 'assigns @result' do
      expect(assigns(:result)).to eq(result)
    end

    it "renders 'order_items/create' template" do
      expect(response).to render_template('order_items/create')
    end
  end

  describe 'PUT #update' do
    let(:order_item) { create(:order_item) }
    let(:order) { order_item.order }
    let(:params) { { id: order_item.id, quantity: order_item.quantity + 1, action: 'update' } }
    let(:result) { OrderItemService.new(order, ActionController::Parameters.new(params)).call }
    before do
      session[:order_id] = order.id
      put :update, xhr: true, params: params
    end

    it { is_expected.to use_before_action(:order_item_service) }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns @result' do
      expect(assigns(:result)).to eq(result)
    end

    it 'checks the number of order_item' do
      quantity = order_item.quantity
      order_item.reload
      expect(order_item.quantity).to eq(quantity + 1)
    end

    it "renders 'order_items/update' template" do
      expect(response).to render_template('order_items/update')
    end
  end

  describe 'DELETE #destroy' do
    let(:order_item) { create(:order_item) }
    let(:order) { order_item.order }
    let(:params) { { id: order_item.id, action: 'destroy' } }
    let(:result) { OrderItemService.new(order, ActionController::Parameters.new(params)).call }
    before do
      session[:order_id] = order.id
      delete :destroy, xhr: true, params: params
    end

    it { is_expected.to use_before_action(:order_item_service) }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'destroy order_item' do
      expect(OrderItem.find_by(id: order_item.id)).to eq(nil)
    end

    it "renders 'order_items/destroy' template" do
      expect(response).to render_template('order_items/destroy')
    end
  end
end
