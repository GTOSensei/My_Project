# frozen_string_literal: true

RSpec.describe 'Home page', type: :feature do
  let!(:categories) { create_list(:category, 4) }
  let(:lattest_books) { Book.lattest_books.decorate }
  let(:best_sellers) { BookDecorator.best_sellers }
  before :each do
    visit root_path
  end

  context 'checks links on page, header and footer' do
    { 'Home' => :root_path, 'Log In' => :user_session_path,
      'Sing Up' => :new_user_registration_path, '0' => :cart_path }.each do |name_page, page_path|
      it "link '#{name_page}' in a header" do
        within('header') { click_link name_page }
        expect(page).to have_current_path(send(page_path))
      end
    end

    it "link 'Home' in a footer" do
      within('footer') { click_link 'Home' }
      expect(page).to have_current_path(root_path)
    end

    %w[header footer].each do |element|
      it "link 'Shop' in a #{element}" do
        categories.each do |category|
          within(element) { click_link(category.title) }
          expect(page).to have_current_path(books_path(category: category.title))
        end
      end
    end

    it "link '#{I18n.t('button.started')}' in a page" do
      click_link(I18n.t('button.started'))
      expect(page).to have_current_path(books_path)
    end

    it "link '#{I18n.t('button.buy_now')}'", js: true do
      click_link(I18n.t('button.buy_now'), match: :first)
      expect(find('header')).to have_content('1')
    end

    it "link 'books/id'", js: true do
      first(:css, 'i.fa.fa-eye.thumb-icon').click
      expect(page).to have_current_path(book_path(best_sellers.first))
    end

    it 'link add book to cart', js: true do
      first(:css, 'i.fa.fa-shopping-cart.thumb-icon').click
      expect(find('header')).to have_content('1')
    end
  end

  context 'no links if user is not logged in' do
    ['Admin Panel', 'My account', 'Orders', 'Settings'].each do |link|
      it "have no link '#{link}'" do
        expect(page).to have_no_link(link)
      end
    end
  end

  context 'have new links, if user is authorized' do
    let(:user) { create(:user, admin: true) }
    before(:each) do
      login_as user
      visit root_path
    end

    { 'Admin Panel' => :admin_root_path, 'Settings' => :edit_user_registration_path,
      'Orders' => :orders_path }.each do |name_page, page_path|
      it "have link '#{name_page}'" do
        click_link name_page
        expect(page).to have_current_path(send(page_path))
      end
    end

    it "link 'My account' in a header" do
      { 'Settings' => edit_user_registration_path, 'My Orders' => orders_path,
        'Log out' => root_path }.each do |name_page, page_path|
        within('header') { click_link(name_page) }
        expect(page).to have_current_path(page_path)
      end
    end
  end

  context 'checks content on page and footer' do
    it 'footer content' do
      ['admin@amazing.com', '(097)-911-9191'].each do |content|
        expect(find('footer')).to have_content(content)
      end
    end

    it 'availability of content books lattest_books' do
      lattest_books.each do |book|
        [book.title, book.authors].each { |content| expect(page).to have_content(content) }
        expect(page).to have_css("img[alt*=#{book.cover[:name]}]")
      end
    end

    it 'availability of content books Bestsellers' do
      best_sellers.each do |book|
        [book.title, book.price, book.authors].each { |content| expect(page).to have_content(content) }
        expect(page).to have_css("img[alt*=#{book.cover[:name]}]")
      end
    end

    it { expect(page).to have_content(I18n.t('home.welcome')) }
    it { expect(page).to have_content(I18n.t('home.info')) }
  end

  context 'checks quantity of books in cart' do
    let(:order) { create(:order).decorate }
    before(:each) do
      login_as order.user
      visit root_path
    end
    it { expect(find('.shop-quantity')).to have_content(order.total_count) }
  end

  it 'Log In' do
    user = create(:user)
    visit user_session_path
    within('.container.general-main-wrap') do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
    end
    click_button 'Back to Store'
    expect(page).to have_content 'Signed in successfully.'
  end

  it 'Sign Up' do
    visit new_user_registration_path
    within('.container.general-main-wrap') do
      fill_in 'Email', with: 'test@smail.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
    end
    click_button 'Sign Up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(page).to have_current_path(root_path)
  end
end
