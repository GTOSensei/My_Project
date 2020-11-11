# frozen_string_literal: true

RSpec.describe 'Checkouts page', type: :feature do
  let(:order) { create(:order).decorate }
  before :each do
    login_as order.user
  end

  context 'checkout address' do
    let!(:country) { create(:country, name: 'Ukraine', phone_code: '+380') }
    before { visit checkouts_path }

    it 'use billing address' do
      within('.col-md-5.mb-40') do
        fill_in('order[billing_address][firstname]', with: 'Alex')
        fill_in('order[billing_address][lastname]', with: 'Doe')
        fill_in('order[billing_address][address]', with: 'Kirova 112')
        fill_in('order[billing_address][city]', with: 'Dnipro')
        fill_in('order[billing_address][zip]', with: '49000')
        fill_in('order[billing_address][phone]', with: '+380975559999')
        select(country.name, from: 'order[billing_address][country_id]')
      end
      check 'order[use_billing]'
      click_button(I18n.t('button.save_continue'))
      expect(page).to have_current_path("#{checkouts_path}/delivery")
    end

    it 'Order Summary' do
      [I18n.t('summary.subtotal'), "#{I18n.t('currency_sign')}#{order.subtotal}",
       I18n.t('summary.coupon'), "#{I18n.t('currency_sign')}#{order.discount}",
       I18n.t('summary.order_total'), "#{I18n.t('currency_sign')}#{order.order_total}"].each do |context|
        expect(page).to have_content(context)
      end
    end
  end

  context 'checkout delivery' do
    let!(:deliveries) { create_list(:delivery, 4) }
    before do
      create(:billing_address, addressable: order)
      create(:shipping_address, addressable: order)
      visit checkouts_path
    end

    it 'add delivery' do
      choose deliveries.first.name
      click_button(I18n.t('button.save_continue'))
      expect(page).to have_current_path("#{checkouts_path}/payment")
    end

    it 'content deliveries' do
      deliveries.each do |delivery|
        [delivery.name, delivery.terms, delivery.price].each do |content|
          expect(page).to have_content(content)
        end
      end
    end
  end

  context 'checkout payment' do
    before do
      create(:billing_address, addressable: order)
      create(:shipping_address, addressable: order)
      order.update(delivery: create(:delivery))
      visit checkouts_path
    end

    it 'add payment' do
      fill_in('order[credit_card][number]', with: '12345678901234')
      fill_in('order[credit_card][card_owner]', with: 'Alex Doe')
      fill_in('order[credit_card][expiry_date]', with: '12/20')
      fill_in('cvv', with: '111')
      click_button(I18n.t('button.save_continue'))
      expect(page).to have_current_path("#{checkouts_path}/confirm")
    end
  end

  context 'checkout confirm' do
    let!(:order_new) { create(:order, :with_associations).decorate }
    before do
      login_as order_new.user
      visit checkouts_path
    end

    it "click on '#{I18n.t('button.place_order')}'" do
      click_on(I18n.t('button.place_order'))
      expect(page).to have_current_path("#{checkouts_path}/complete")
    end

    %i[firstname lastname city zip address phone].each do |field|
      it { expect(page).to have_content(order_new.billing_address.send(field)) }
      it { expect(page).to have_content(order_new.shipping_address.send(field)) }
    end
    %i[name terms].each do |field|
      it { expect(page).to have_content(order_new.delivery.send(field)) }
    end
    %i[number expiry_date].each do |field|
      it { expect(page).to have_content(order_new.credit_card.send(field)) }
    end

    [I18n.t('headline.book'), I18n.t('headline.price'), I18n.t('headline.quantity'),
     I18n.t('headline.total')].each do |context|
      it { expect(page).to have_content(context) }
    end

    it 'have order_items' do
      order_new.order_items.each do |order_item|
        ["#{I18n.t('currency_sign')}#{order_item.price}", order_item.quantity,
         "#{I18n.t('currency_sign')}#{order_item.sub_total}"].each do |content|
          expect(page).to have_content(content)
          expect(page).to have_css("img[src*=#{order_item.book.decorate.cover[:name]}]")
        end
      end
    end

    it 'link edit of address' do
      all('a.general-edit')[1].click
      expect(page).to have_current_path('/en/checkouts/address?edit=1')
    end

    it 'link edit of delivery' do
      all('a.general-edit')[2].click
      expect(page).to have_current_path('/en/checkouts/delivery?edit=1')
    end
    it 'link edit of payment' do
      all('a.general-edit')[3].click
      expect(page).to have_current_path('/en/checkouts/payment?edit=1')
    end

    it 'link click book_title' do
      book = order_new.order_items.first.book
      click_on(book.title)
      expect(page).to have_current_path(book_path(book))
    end

    it 'Order Summary' do
      [I18n.t('summary.subtotal'), "#{I18n.t('currency_sign')}#{order_new.subtotal}",
       I18n.t('summary.coupon'), "#{I18n.t('currency_sign')}#{order_new.discount}",
       I18n.t('summary.delivery'), "#{I18n.t('currency_sign')}#{order_new.delivery_price}",
       I18n.t('summary.order_total'), "#{I18n.t('currency_sign')}#{order_new.order_total}"].each do |context|
        expect(page).to have_content(context)
      end
    end

    context 'checkout complete' do
      let!(:order_new) { create(:order, :with_associations).decorate }
      before do
        login_as order_new.user
        visit "#{checkouts_path}/complete"
      end

      it "click on '#{I18n.t('button.back')}'" do
        click_on(I18n.t('button.back'))
        expect(page).to have_current_path(books_path)
      end

      %i[firstname lastname city zip address phone].each do |field|
        it { expect(page).to have_content(order_new.shipping_address.send(field)) }
      end

      it 'have content of order info' do
        [I18n.t('info.thank_you'), "#{I18n.t('info.order_sent_to')} #{order_new.user.email}",
         "#{I18n.t('info.order')} ##{order_new.order_number}", order_new.created_at.strftime('%B %d, %Y')].each do |content|
          expect(page).to have_content(content)
        end
      end

      it 'have order_items' do
        order_new.order_items.each do |order_item|
          ["#{I18n.t('currency_sign')}#{order_item.price}", order_item.quantity,
           "#{I18n.t('currency_sign')}#{order_item.sub_total}"].each do |content|
            expect(page).to have_content(content)
            expect(page).to have_css("img[src*=#{order_item.book.decorate.cover[:name]}]")
          end
        end
      end

      it 'link click book_title' do
        book = order_new.order_items.first.book
        click_on(book.title)
        expect(page).to have_current_path(book_path(book))
      end

      it 'Order Summary' do
        [I18n.t('summary.subtotal'), "#{I18n.t('currency_sign')}#{order_new.subtotal}",
         I18n.t('summary.coupon'), "#{I18n.t('currency_sign')}#{order_new.discount}",
         I18n.t('summary.delivery'), "#{I18n.t('currency_sign')}#{order_new.delivery_price}",
         I18n.t('summary.order_total'), "#{I18n.t('currency_sign')}#{order_new.order_total}"].each do |context|
          expect(page).to have_content(context)
        end
      end
    end
  end
end
