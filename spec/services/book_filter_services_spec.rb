# frozen_string_literal: true

RSpec.describe BookFilterServices do
  let!(:categories) { create_list(:category, 4) }

  it 'returns a list of books of each category' do
    categories.each do |category|
      BookFilterServices.new(category: category.title).catalog_with_category.each do |book|
        expect(book.categories).to include(category)
      end
    end
  end

  it 'sorts the books of each category by :title_desc' do
    categories.each do |category|
      books = BookFilterServices.new(category: category.title, sort: 'title_desc').catalog_with_category
      expect(books).to eq(category.books.send(:title_desc))
    end
  end

  { '1': 12, '2': 8, '3': 0 }.each do |page, count|
    it "returns page '#{page} : #{count}' of books" do
      books = BookFilterServices.new(page: page.to_s).catalog_with_category
      expect(books.count).to eq(count)
      expect(books.current_page).to eq(page.to_s.to_i)
    end
  end

  context 'checks methods #sort_by' do
    { {} => 'Title: A - Z', { sort: 'popular' } => 'Popular first',
      { sort: 'invalid' } => 'Title: A - Z' }.each do |hash, name|
      it "sorts books by params #{hash}" do
        books_servise = BookFilterServices.new(hash)
        expect(books_servise.sort_by).to eq(name.to_s)
      end
    end
  end
end
