# frozen_string_literal: true

RSpec.describe OrderHelper, type: :helper do
  let(:order) { create(:order, :with_associations).decorate }

  describe '#order_sort_by' do
    it "returns sort order by 'all', if params[:filter] = nil" do
      expect(helper.order_sort_by).to eq(I18n.t('sort').fetch(:all))
    end

    it "returns sort order by 'all', if params[:filter] is not valid" do
      controller.params[:filter] = 'in_delivery999'
      expect(helper.order_sort_by).to eq(I18n.t('sort').fetch(:all))
    end

    I18n.t('sort').keys.each do |filter|
      it "returns order sort by #{filter}" do
        controller.params[:filter] = filter
        expect(helper.order_sort_by).to eq(I18n.t('sort').fetch(filter))
      end
    end
  end

  describe '#status' do
    let(:statuses) { Order.statuses.keys.push('all') }

    it "returns order sort by status 'in_queue'" do
      order.in_queue!
      expect(helper.status(order.status)).to eq(I18n.t('sort').fetch(order.status.to_sym))
    end

    I18n.t('sort').keys.each do |status|
      it "order statuses include #{status}" do
        expect(statuses).to include(status.to_s)
      end
    end
  end

  describe '#order_total_count' do
    helper do
      def current_order; end
    end
    it 'returns total order amount' do
      allow(helper).to receive(:current_order).and_return order
      expect(helper.order_total_count).to eq(order.total_count)
    end
  end
end
