# frozen_string_literal: true

class BooksController < ApplicationController
  def index
    @services = BookFilterServices.new(params)
    @books = @services.catalog_with_category
    respond_to :html, :js
  end

  def show
    @book = Book.find_by(id: params[:id]).try(:decorate)
    return redirect_to books_path, alert: t('errors.nil_book') if @book.blank?

    @reviews = @book.reviews.approved.decorate
  end
end
