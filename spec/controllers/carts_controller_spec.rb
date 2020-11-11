# frozen_string_literal: true

RSpec.describe CartsController, type: :controller do
  describe 'PUT #update' do
    let(:order) { create(:order) }
    let(:coupon) { create(:coupon) }
    before do
      session[:order_id] = order.id
      put :update, xhr: true, params: { code: coupon.code }
    end

    it 'coupon successfully applied' do
      expect(assigns(:coupon_applied)).to be true
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it "renders 'carts/update' template" do
      expect(response).to render_template('carts/update')
    end

    it 'coupon applied to order' do
      order.reload
      expect(order.coupon_id).to eq(coupon.id)
    end

    context 'invalid coupon and not applied to order' do
      let(:order1) { create(:order) }
      before do
        session[:order_id] = order1.id
        put :update, xhr: true, params: { code: '123' }
      end

      it 'coupon not applied to order' do
        order1.reload
        expect(order.coupon_id).to_not eq(coupon.id)
        expect(order1.coupon_id).to eq(nil)
      end

      it 'invalid coupon' do
        expect(assigns(:coupon_applied)).to be false
      end
    end

    it "route '/cart' matcher test" do
      expect route(:put, '/cart').to(action: :update)
    end
  end

  describe 'show action' do
    it 'renders the show template' do
      get :show
      expect(response).to render_template(:show)
    end
  end
end
