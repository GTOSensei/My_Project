# frozen_string_literal: true

RSpec.describe 'Books page', type: :feature do
  let(:categories) { create_list(:category, 4) }
  let(:books) { BookFilterServices.new({}).catalog_with_category }
  before :each do
    create_list(:book, 15, categories: [categories.first])
    visit books_path
  end

  context 'checks context and links on page' do
    it 'availability of book content sorted by default' do
      books.each do |book|
        [book.title, book.price, book.authors].each { |content| expect(page).to have_content(content) }
        expect(page).to have_css("img[alt*=#{book.cover[:name]}]")
      end
    end

    it 'shows 12 books' do
      expect(books.count).to eq(12)
    end

    it 'link add book to cart', js: true do
      first(:css, 'i.fa.fa-shopping-cart.thumb-icon').click
      expect(find('header')).to have_content('1')
    end

    it "link 'books/id'", js: true do
      first(:css, 'i.fa.fa-eye.thumb-icon').click
      expect(page).to have_current_path(book_path(books.first))
    end

    it "button click '#{I18n.t('button.view_more')}'" do
      click_link(I18n.t('button.view_more'))
      expect(page).to have_current_path('/en/books?page=2')
    end

    it 'checks quantity of books in each category' do
      categories.each do |category|
        expect(find('ul.list-inline.pt-10.mb-25.mr-240')).to have_content("#{category.title}#{category.books.count}")
      end
    end

    it 'checks total quantity of books in all categories' do
      expect(find('ul.list-inline.pt-10.mb-25.mr-240')).to have_content("All#{Book.count}")
    end
  end

  context 'checks sorting of books and lack of button' do
    let(:category) { categories.last }
    before :each do
      visit books_path(category: category.title)
    end

    it "lack of button #{I18n.t('button.view_more')}" do
      expect(page).to have_no_link(I18n.t('button.view_more'))
    end

    I18n.t('filter_book').each do |filter, link_name|
      it "sort by #{link_name}" do
        find_all('a', text: link_name).last.click
        expect(page).to have_current_path(books_path(category: category.title, sort: filter))
      end
    end
  end
end
