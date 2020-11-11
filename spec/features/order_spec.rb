# frozen_string_literal: true

RSpec.describe 'Order page', type: :feature do
  let(:order) { create(:order, :with_associations, status: 2).decorate }
  before :each do
    login_as order.user
    visit order_path(order)
  end

  %i[billing_address shipping_address].each do |type|
    it "have '#{type}'" do
      [order.send(type).firstname, order.send(type).lastname, order.send(type).address,
       "#{order.send(type).city} #{order.send(type).zip}", order.send(type).country.name,
       order.send(type).phone].each do |content|
        expect(page).to have_content(content)
      end
    end
  end

  it "have 'Shipments'" do
    [order.delivery.name, order.delivery.terms].each do |content|
      expect(page).to have_content(content)
    end
  end

  it "have 'Payment Information'" do
    [order.credit_card.expiry_date, "** ** ** #{order.credit_card.number}"].each do |content|
      expect(page).to have_content(content)
    end
  end

  it 'have order number' do
    expect(page).to have_content(order.order_number)
  end

  [I18n.t('address.shipping_address'), I18n.t('address.billing_address'), I18n.t('delivery.shipments'),
   I18n.t('credit_card.payment_info'), I18n.t('headline.book'), I18n.t('headline.price'),
   I18n.t('headline.quantity'), I18n.t('headline.total')].each do |content|
    it "have heading '#{content}'" do
      expect(page).to have_content(content)
    end
  end

  it 'have Subtotal' do
    expect(page).to have_content(I18n.t('summary.subtotal') + "#{I18n.t('currency_sign')}#{order.subtotal}")
  end

  it 'have Coupon' do
    expect(page).to have_content(I18n.t('summary.coupon') + "#{I18n.t('currency_sign')}#{order.discount}")
  end

  it 'have Delivery' do
    expect(page).to have_content(I18n.t('summary.delivery') + "#{I18n.t('currency_sign')}#{order.delivery_price}")
  end

  it 'have Order Total' do
    expect(page).to have_content(I18n.t('summary.order_total') + "#{I18n.t('currency_sign')}#{order.order_total}")
  end

  it 'have order_items' do
    order.order_items.each do |order_item|
      [order_item.book.decorate.description[0..230], "#{I18n.t('currency_sign')}#{order_item.price}",
       order_item.quantity, "#{I18n.t('currency_sign')}#{order_item.sub_total}"].each do |content|
        expect(page).to have_content(content)
        expect(page).to have_css("img[alt*=#{order_item.book.decorate.cover[:name]}]")
      end
    end
  end

  it 'has a link to book' do
    within('tbody') { click_link(order.order_items.first.book.title) }
    expect(page).to have_current_path(book_path(order.order_items.first.book))
  end
end
