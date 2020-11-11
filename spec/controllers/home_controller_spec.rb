# frozen_string_literal: true

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    before { get :index }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end

    it 'assigns @lattest_books' do
      expect(assigns(:lattest_books)).to eq(Book.lattest_books.decorate)
    end

    it 'assigns @best_sellers' do
      expect(assigns(:best_sellers)).to eq(BookDecorator.best_sellers)
    end

    it 'assigns not nil @lattest_books' do
      expect(assigns(:lattest_books)).not_to be_nil
    end

    it 'assigns not nil @best_sellers' do
      expect(assigns(:best_sellers)).not_to be_nil
    end

    it "route 'home#index' matcher test" do
      expect route(:get, 'home#index').to(action: :index)
    end
  end
end
