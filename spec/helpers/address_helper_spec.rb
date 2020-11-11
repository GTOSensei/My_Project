# frozen_string_literal: true

RSpec.describe AddressHelper, type: :helper do
  let(:user) { create(:user, :with_addresses) }
  let(:order) { create(:order, user: user) }

  describe '#error_address?' do
    %i[firstname lastname address city zip country_id phone].each do |field|
      it "returns false if '#{field}' field is valid" do
        expect(helper.error_address?(field, user.billing_address)).to be false
      end
    end
  end

  describe '#error_key' do
    %i[firstname lastname address city zip country_id phone].each do |field|
      it "returns '' if '#{field}' field is valid" do
        expect(helper.error_key(field, user.billing_address)).to eq('')
      end
    end
  end

  describe '#order_billing and #order_shipping' do
    context 'returns user billing_address and shipping_address' do
      before do
        assign(:order, order)
        assign(:user, user)
      end
      it 'returns user billing_address' do
        expect(helper.order_billing).to eq(user.billing_address)
      end

      it 'returns user shipping_address' do
        expect(helper.order_shipping).to eq(user.shipping_address)
      end
    end

    context 'returns order billing_address and shipping_address' do
      before do
        @order = create(:order, :with_associations)
        assign(:order, @order)
        assign(:user, @order.user)
      end
      it 'returns order billing_address' do
        expect(helper.order_billing).to eq(@order.billing_address)
      end

      it 'returns order shipping_address' do
        expect(helper.order_shipping).to eq(@order.shipping_address)
      end
    end
  end
end
