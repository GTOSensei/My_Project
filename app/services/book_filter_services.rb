# frozen_string_literal: true

class BookFilterServices
  LIMIT_BOOKS = 12

  def initialize(params)
    @params = params
  end

  def catalog_with_category
    books = catalog.call(Book)
    books.send(sort).page(@params[:page]).per(LIMIT_BOOKS).decorate
  end

  def sort_by
    I18n.t('filter_book').fetch(sort.to_sym)
  end

  private

  def catalog
    lambda do |object|
      return object if category.blank?

      object.books_category(category)
    end
  end

  def category
    @params[:category]
  end

  def sort
    return @params[:sort] if @params[:sort] && I18n.t('filter_book').include?(@params[:sort].to_sym)

    I18n.t('filter_book').keys[4]
  end
end
