# frozen_string_literal: true

RSpec.describe CheckoutsController, type: :controller do
  let!(:order) { create(:order, :with_associations) }
  let(:user) { order.user }
  before do
    sign_in user
    session[:order_id] = order.id
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:current_order).and_return(order)
  end

  describe 'GET #show' do
    before { get :show, params: { id: 'login' } }

    it { is_expected.to use_before_action(:authenticate_user!) }
    it { is_expected.to use_before_action(:current_data) }
    it 'assigns not nil @order' do
      expect(assigns(:order)).not_to be_nil
    end
    it 'assigns not nil @user' do
      expect(assigns(:user)).not_to be_nil
    end
    it 'order billing_address is not nil' do
      expect(order.billing_address).not_to be_nil
    end
    it 'order shipping_address is not nil' do
      expect(order.shipping_address).not_to be_nil
    end
    it 'order delivery is not nil' do
      expect(order.delivery).not_to be_nil
    end
    it 'order credit_card is not nil' do
      expect(order.credit_card).not_to be_nil
    end

    it "'checkouts/complete' status 'in_queue' " do
      get :show, params: { id: :complete }
      expect(order.status).to eq('in_queue')
    end

    context 'returns render_template and redirect_to' do
      %i[confirm complete].each do |step|
        it "render_template #{step}" do
          get :show, params: { id: step }
          expect(response).to render_template(step)
          expect(response).to have_http_status 200
        end
        it "route '/checkouts/#{step}' matcher test" do
          expect route(:get, "/checkouts/#{step}").to(action: :show, id: step)
        end
      end
      %i[login address delivery payment].each do |step|
        it 'redirect_to confirm' do
          get :show, params: { id: step }
          is_expected.to redirect_to '/en/checkouts/confirm'
        end
        it "'checkouts/#{step}' status 'in_progress' " do
          expect(order.status).to eq('in_progress')
        end
        it "route '/checkouts/confirm' matcher test" do
          expect route(:get, '/checkouts/confirm').to(action: :show, id: step)
        end
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user) }
    let(:order) { create(:order, user: user).decorate }
    before do
      sign_in user
      session[:order_id] = order.id
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:current_order).and_return(order)
    end

    %i[address delivery payment].each do |step|
      describe "checkout #{step}" do
        context "invalid #{step}" do
          before do
            case step
            when :address
              put :update, params: { id: 'address', order: {
                billing_address: BillingAddress.new.attributes, shipping_address: ShippingAddress.new.attributes
              } }
            when :delivery
              put :update, params: { id: 'delivery', order: { order_id: order.id } }
            when :payment
              put :update, params: { id: 'payment', order: { credit_card: CreditCard.new.attributes } }
            end
          end
          it { expect route(:put, "/checkouts/#{step}").to(action: :update, id: step) }
          it { expect(response).to render_template(step) }
          it { expect(flash.now[:alert]).to eq(ErrorsService.new(order, step).call) }
        end

        context "valid #{step}" do
          before do
            case step
            when :address
              billing = create(:billing_address, addressable: order)
              shipping = create(:shipping_address, addressable: order)
              @next_step = 'delivery'
              put :update, params: { id: 'address', order: {
                billing_address: billing.attributes, shipping_address: shipping.attributes
              } }
            when :delivery
              delivery = create(:delivery)
              put :update, params: { id: 'delivery', order: { order_id: order.id, delivery_id: delivery.id } }
              @next_step = 'payment'
            when :payment
              credit_card = create(:credit_card, order: order)
              put :update, params: { id: 'payment', order: { credit_card: credit_card.attributes } }
              @next_step = 'confirm'
            end
          end
          it { is_expected.to redirect_to "/en/checkouts/#{@next_step}" }
          it { expect route(:put, "/checkouts/#{@next_step}").to(action: :update, id: @next_step) }
        end
      end
    end
  end
end
