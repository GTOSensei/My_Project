# frozen_string_literal: true

RSpec.describe OrdersController, type: :controller do
  describe 'index action' do
    let(:order) { create(:order) }
    let(:orders) { OrdersFilterService.new(order.user, :all).call.decorate }
    before { sign_in(order.user) }
    before { get :index }

    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end

    it 'assigns @orders' do
      expect(assigns(:orders)).to eq(orders)
    end

    it 'assigns not nil @orders' do
      expect(assigns(:orders)).not_to be_nil
    end

    it "route '/orders' matcher test" do
      expect route(:get, '/orders').to(action: :index)
    end
  end

  describe 'show action' do
    let(:order) { create(:order) }
    before { sign_in(order.user) }
    before { get :show, params: { id: order.id } }

    it 'renders the show template' do
      expect(response).to render_template(:show)
    end

    it 'assigns @order' do
      expect(assigns(:order)).to eq(order)
    end

    it 'assigns not nil @order' do
      expect(assigns(:order)).not_to be_nil
    end

    it "route '/orders/id' matcher test" do
      expect route(:get, "/orders/#{order.id}").to(action: :show, id: order.id)
    end
  end
end
