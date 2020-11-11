# frozen_string_literal: true

class ReviewsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def create
    @review = Review.create(review_params)
    return redirect_to @review.book, notice: I18n.t('review.msg') if @review.valid?

    flash.now[:alert] = @review.errors.full_messages.join(', ')
    show_render
  end

  private

  def show_render
    @book = @review.book.decorate
    @reviews = @book.reviews.approved.decorate
    render 'books/show'
  end

  def review_params
    params.require(:review).permit(:title, :comment, :rating, :book_id, :user_id)
  end
end
