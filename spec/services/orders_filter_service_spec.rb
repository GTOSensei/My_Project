# frozen_string_literal: true

RSpec.describe OrdersFilterService do
  let(:user) { create(:user) }
  let!(:orders) { create_list(:order, 8, user: user) }
  before do
    user.orders.each do |order|
      order.status = Order.statuses.keys.sample.to_s
      order.save
    end
  end

  ['FDSFDS', '5444', '', nil].each do |filter|
    it "returns user.orders.accepted if filter = #{filter}" do
      expect(OrdersFilterService.new(user, filter).call).to eq(user.orders.accepted)
    end
  end

  I18n.t('sort').keys.each do |filter|
    it "returns user.orders.accepted.#{filter} if filter = #{filter}" do
      expect(OrdersFilterService.new(user, filter).call).to eq(user.orders.accepted.send(filter))
    end
  end
end
