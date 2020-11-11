# frozen_string_literal: true

RSpec.describe CheckoutsHelper, type: :helper do
  let(:order) { create(:order, :with_associations) }

  describe '#errors_card?' do
    before { assign(:order, order) }
    %i[number card_owner expiry_date order_id].each do |field|
      it "returns false if '#{field}' field is valid" do
        expect(helper.errors_card?(field)).to be false
      end
    end
  end

  describe '#error' do
    before { assign(:order, order) }
    %i[number card_owner expiry_date order_id].each do |field|
      it "returns '' if '#{field}' field is valid" do
        expect(helper.error(field)).to eq('')
      end
    end
  end

  describe '#mask_card' do
    before { assign(:order, order) }
    it 'returns masked credit card' do
      expect(helper.mask_card).to eq("** ** ** #{order.credit_card.number}")
    end
  end
end
