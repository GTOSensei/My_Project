# frozen_string_literal: true

RSpec.describe 'Cart page', type: :feature do
  context 'empty cart' do
    before :each do
      visit cart_path
    end

    it { expect(page).to have_content(I18n.t('cart.name')) }

    it 'message no items' do
      expect(page).to have_content(I18n.t('cart.no_items') + I18n.t('cart.go_back') + I18n.t('cart.to_cart'))
    end

    it "have link 'go back'" do
      click_link(I18n.t('cart.go_back'))
      expect(page).to have_current_path(root_path)
    end
  end

  context 'items in cart' do
    let(:user) { create(:user) }
    let!(:order) { create(:order, user: user).decorate }
    let(:coupon) { create(:coupon) }
    before :each do
      login_as user
      visit cart_path
    end

    [I18n.t('headline.book'), I18n.t('headline.price'), I18n.t('headline.quantity'),
     I18n.t('headline.subtotal'), I18n.t('cart.code')].each do |context|
      it { expect(page).to have_content(context) }
    end

    it "button click '#{I18n.t('cart.apply_coupon')}'", js: true do
      within('.general-order-wrap') do
        fill_in 'code', with: coupon.code
        click_on(I18n.t('cart.apply_coupon'))
      end
      page.execute_script 'window.confirm = function () { return true }'
      discount = "#{I18n.t('summary.coupon')}#{I18n.t('currency_sign')}#{coupon.discount}"
      expect(find('.col-sm-8')).to have_content(discount)
    end

    it "button click '#{I18n.t('checkout.check')}'" do
      click_on(I18n.t('checkout.check'))
      expect(page).to have_current_path('/en/checkouts/address')
    end

    it 'have order_items' do
      order.order_items.each do |order_item|
        ["#{I18n.t('currency_sign')}#{order_item.book.decorate.price}", order_item.book.decorate.title,
         "#{I18n.t('currency_sign')}#{order_item.sub_total}"].each do |content|
          expect(page).to have_content(content)
          expect(page).to have_css("img[src*=#{order_item.book.decorate.cover[:name]}]")
        end
      end
    end

    it 'link click book_title' do
      book = order.order_items.first.book.decorate
      click_on(book.title)
      expect(page).to have_current_path(book_path(book))
    end

    it 'have Coupon' do
      expect(page).to have_content(I18n.t('summary.coupon') + "#{I18n.t('currency_sign')}#{order.discount}")
    end

    it 'click delete order_item', js: true do
      book = order.order_items.first.book.decorate
      within('table') { click_on('×') }
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_no_content(book.title)
      expect(order.order_items.count).to eq(3)
      expect(page).to have_content(I18n.t('summary.order_total') + "#{I18n.t('currency_sign')}#{order.order_total}")
      expect(page).to have_content(I18n.t('summary.subtotal') + "#{I18n.t('currency_sign')}#{order.subtotal}")
    end

    it 'quantity of books plus one', driver: :selenium do
      quantity = order.order_items.id_asc.first.quantity.to_i + 1
      first(:css, 'i.fa.fa-plus').click
      expect(find_field('order_item[quantity]', disabled: true).value).to eq(quantity.to_s)
      expect(page).to have_content(I18n.t('summary.order_total') + "#{I18n.t('currency_sign')}#{order.order_total}")
      expect(page).to have_content(I18n.t('summary.subtotal') + "#{I18n.t('currency_sign')}#{order.subtotal}")
    end

    it 'quantity of books minus one', driver: :selenium do
      quantity = order.order_items.id_asc.first.quantity.to_i - 1
      first(:css, 'i.fa.fa-minus').click
      expect(find_field('order_item[quantity]', disabled: true).value).to eq(quantity.to_s)
      expect(page).to have_content(I18n.t('summary.order_total') + "#{I18n.t('currency_sign')}#{order.order_total}")
      expect(page).to have_content(I18n.t('summary.subtotal') + "#{I18n.t('currency_sign')}#{order.subtotal}")
    end
  end
end
