# frozen_string_literal: true

class BookDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def cover
    if object.images.present?
      { url: object.images.first.variant(resize: '485x580!'), name: object.images.first.filename }
    else
      { url: 'no_cover.jpg', name: 'no_cover' }
    end
  end

  def authors
    object.authors.map(&:to_s).join(', ')
  end

  def self.best_sellers
    decorate_collection(Category.all.map { |category| category.books.popular.first })
  end
end
