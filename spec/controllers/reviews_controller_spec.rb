# frozen_string_literal: true

RSpec.describe ReviewsController, type: :controller do
  describe 'POST #create' do
    let(:book) { create(:book) }
    let(:user) { create(:user) }
    let(:review_params) { { book_id: book.id, review: { title: 'title', comment: 'comment', rating: 5, book_id: book.id, user_id: user.id } } }
    before do
      sign_in(user)
      post :create, params: review_params
    end

    it { is_expected.to use_before_action(:authenticate_user!) }

    it 'assigns not nil @review' do
      expect(assigns(:review)).not_to be_nil
    end

    it 'assigns @review' do
      expect(assigns(:review)).to eq(book.reviews.last)
    end

    it 'status unprocessed?' do
      expect(assigns(:review).unprocessed?).to be true
    end

    it 'redirect_to @book' do
      is_expected.to redirect_to(book)
    end

    it { is_expected.to set_flash[:notice].to(I18n.t('review.msg')) }

    it 'permit was called with the correct arguments' do
      is_expected.to permit(:title, :comment, :rating, :book_id, :user_id)
        .for(:create, params: review_params).on(:review)
    end

    it "route '/books/id' matcher test" do
      expect route(:get, "/books/#{book.id}").to(action: :create)
    end

    context 'invalid parameters' do
      before { post :create, params: { book_id: book.id, review: { title: '5', rating: 3, user_id: user.id, book_id: book.id } } }

      it "render 'books/show'" do
        expect(response).to render_template('books/show')
      end

      it "route '/books/id/reviews' matcher test" do
        expect route(:get, "/books/#{book.id}/reviews").to(action: :create)
      end

      it 'assigns @book' do
        expect(assigns(:book)).to eq(book.decorate)
      end

      it 'assigns @reviews' do
        expect(assigns(:reviews)).to eq(book.reviews.approved.decorate)
      end

      it { expect(flash[:alert]).to eq("Title is invalid, Comment is invalid, Comment can't be blank") }
    end
  end
end
