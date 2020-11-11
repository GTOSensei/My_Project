# frozen_string_literal: true

RSpec.describe 'Orders page', type: :feature do
  let(:user) { create(:user) }
  let(:orders) { OrderDecorator.decorate_collection(create_list(:order, 5, :with_associations, user: user)) }
  let(:order) { orders.first }
  before :each do
    orders.each do |order|
      order.status = Order.statuses.keys[1..-1].sample.to_s
      order.save
    end
    login_as user
    visit orders_path
  end

  it { expect(page).to have_content(I18n.t('info.order')) }

  [I18n.t('order.number'), I18n.t('order.completed'), I18n.t('order.status'), I18n.t('order.total')].each do |content|
    it "column presence #{content}" do
      expect(page).to have_content(content)
    end
  end

  it 'availability of orders content' do
    orders.each do |order|
      [order.order_number, I18n.t('sort').fetch(order.status.to_sym),
       order.completed, order.order_total].each do |content|
        expect(page).to have_content(content)
      end
    end
  end

  it 'link order_number in a table' do
    within('tbody') { click_link(order.order_number) }
    expect(page).to have_current_path(order_path(order))
  end

  I18n.t('sort').each do |filter, link_name|
    it "filter: #{link_name}" do
      find_all('a', text: link_name).last.click
      expect(page).to have_current_path(orders_path(filter: filter))
    end
  end
end
