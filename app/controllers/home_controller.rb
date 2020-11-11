# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @lattest_books = Book.lattest_books.decorate
    @best_sellers = BookDecorator.best_sellers
  end
end
