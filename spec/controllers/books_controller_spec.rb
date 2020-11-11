# frozen_string_literal: true

RSpec.describe BooksController, type: :controller do
  describe 'index action' do
    let(:category) { create(:category) }
    let(:services) { BookFilterServices.new(category: category.title, sort: 'popular') }
    let(:books) { services.catalog_with_category }
    before { get :index, params: { category: category.title, sort: 'popular' } }

    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end

    it 'assigns not nil @services' do
      expect(assigns(:services)).not_to be_nil
    end

    it 'assigns @books' do
      expect(assigns(:books)).to eq(books)
    end

    it 'assigns not nil @books' do
      expect(assigns(:books)).not_to be_nil
    end

    it "route '/books' matcher test" do
      expect route(:get, '/books').to(action: :index)
    end
  end

  describe 'show action' do
    let(:book) { create(:book) }
    let(:reviews) { book.reviews }
    before { get :show, params: { id: book.id } }

    it 'renders the show template' do
      expect(response).to render_template(:show)
    end

    it 'assigns @book' do
      expect(assigns(:book)).to eq(book)
    end

    it 'assigns @reviews' do
      expect(assigns(:reviews)).to eq(reviews)
    end

    it "route '/books/id' matcher test" do
      expect route(:get, "/books/#{book.id}").to(action: :index, id: book.id)
    end
  end
end
