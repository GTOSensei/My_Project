# frozen_string_literal: true

RSpec.describe FilterCheckoutsService do
  let(:order) { create(:order) }
  let(:user) { order.user }
  let(:steps) { %i[login address delivery payment confirm complete] }

  context 'returns checkouts\login, user is not logged in' do
    it "redirect to 'login' at every step" do
      steps.each do |step|
        next if step == CheckoutConst::LOGIN

        expect(FilterCheckoutsService.new(nil, order, id: step).call).to eq(redirect: :login, render: nil)
      end
    end
    it "returns { redirect: 'login', render: 'login' } if id: 'login'" do
      expect(FilterCheckoutsService.new(nil, order, id: :login).call).to eq(redirect: :login, render: :login)
    end
  end

  context 'returns checkouts\address, user is logged in' do
    it "redirect to 'address' at every step if the address is missing" do
      steps.each do |step|
        next if step == CheckoutConst::ADDRESS

        expect(FilterCheckoutsService.new(user, order, id: step).call).to eq(redirect: :address, render: nil)
      end
    end
    it "returns { redirect: 'address', render: 'address' } if id: 'address'" do
      expect(FilterCheckoutsService.new(user, order, id: :address).call).to eq(redirect: :address, render: :address)
    end
  end

  context 'returns checkouts\delivery, user is logged in' do
    before do
      country = create(:country)
      params = { firstname: 'Alex', lastname: 'Doe', address: 'Aliza Court', city: 'Dnipro',
                 zip: '49000', phone: "#{country.phone_code}123456789", country_id: country.id }
      order.create_billing_address(params)
      order.create_shipping_address(params)
    end
    it "redirect to 'delivery' at each stage, if the address is not empty" do
      steps.each do |step|
        next if step == CheckoutConst::DELIVERY

        expect(FilterCheckoutsService.new(user, order, id: step).call).to eq(redirect: :delivery, render: nil)
      end
    end
    it "returns { redirect: 'delivery', render: 'delivery' } if id: 'delivery'" do
      expect(FilterCheckoutsService.new(user, order, id: :delivery).call).to eq(redirect: :delivery, render: :delivery)
    end
  end

  context 'returns checkouts\payment, user is logged in' do
    before do
      delivery = create(:delivery)
      order.update(delivery: delivery)
    end
    it "redirect to 'payment' at each stage, if the delivery is not empty" do
      steps.each do |step|
        next if step == CheckoutConst::PAYMENT

        expect(FilterCheckoutsService.new(user, order, id: step).call).to eq(redirect: :payment, render: nil)
      end
    end
    it "returns { redirect: 'payment', render: 'payment' } if id: 'payment'" do
      expect(FilterCheckoutsService.new(user, order, id: :payment).call).to eq(redirect: :payment, render: :payment)
    end
  end

  context 'returns checkouts\confirm, user is logged in' do
    before do
      credit_card = create(:credit_card)
      order.update(credit_card: credit_card)
    end
    it "redirect to 'confirm' at each stage, if the payment is not empty" do
      steps[0...-2].each do |step|
        expect(FilterCheckoutsService.new(user, order, id: step).call).to eq(redirect: :confirm, render: nil)
      end
    end
    it "returns { redirect: 'confirm', render: 'confirm' } if id: 'confirm'" do
      expect(FilterCheckoutsService.new(user, order, id: :confirm).call).to eq(redirect: :confirm, render: :confirm)
    end
    it "order status 'in_progress'" do
      FilterCheckoutsService.new(user, order, id: :confirm).call
      expect(order.status).to eq('in_progress')
    end
  end

  context 'returns checkouts\complete, user is logged in' do
    let(:order) { create(:order, :with_associations) }
    let(:user) { order.user }
    let!(:filter) { FilterCheckoutsService.new(user, order, id: :complete).call }

    it "returns { redirect: 'confirm', render: 'complete' }" do
      expect(filter).to eq(redirect: :confirm, render: :complete)
    end

    it "returns order status 'in_queue'" do
      expect(order.status).to eq('in_queue')
    end
  end
end
