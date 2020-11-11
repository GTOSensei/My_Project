# frozen_string_literal: true

RSpec.describe BookDecorator do
  let(:authors) { create_list(:author, 2) }
  let(:book) { create(:book, authors: authors).decorate }

  describe '#cover' do
    it 'returns no_cover.jpg if the book has no skin' do
      expect(book.cover).to eq(url: 'no_cover.jpg', name: 'no_cover')
    end

    it 'returns first cover book' do
      book.images.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'avatar.jpg')), \
                         filename: 'avatar.jpg', content_type: 'image/jpg')
      expect(book.cover[:name]).to eq(book.images.first.filename)
    end
  end

  describe '#authors' do
    it 'returns the authors string' do
      expect(book.authors).to eq(authors.map(&:to_s).join(', '))
    end
  end

  describe '#self.best_sellers' do
    let!(:categories) { create_list(:category, 4) }
    it 'returns best_sellers' do
      best_sellers = BookDecorator.decorate_collection(categories.map { |category| category.books.popular.first })
      expect(BookDecorator.best_sellers).to eq(best_sellers)
    end
  end
end
