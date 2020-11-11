# frozen_string_literal: true

ActiveAdmin.register Book do
  menu priority: 2
  permit_params :title, :description, :price, :quantity, :materials, :published_at,
                :height, :width, :depth, images: [], author_ids: [], category_ids: []

  before_save do |book|
    book.dimensions = { height: book.height, width: book.width, depth: book.depth }
  end
  controller do
    def edit
      @book = Book.find(params[:id])
      return unless @book.dimensions?

      @book.height = @book.dimensions[:height]
      @book.width = @book.dimensions[:width]
      @book.depth = @book.dimensions[:depth]
    end
  end

  index do
    selectable_column
    id_column
    column I18n.t('admin.images') do |book|
      if book.images.attached?
        link_to image_tag(book.images.first.variant(resize: '70x100!')), admin_book_path(book)
      else
        link_to image_tag('no_cover.jpg', height: 100), admin_book_path(book)
      end
    end
    column I18n.t('admin.title') do |book|
      link_to book.title, admin_book_path(book)
    end
    column :price do |book|
      number_to_currency(book.price, unit: I18n.t('currency_sign'))
    end
    column :quantity
    column :published_at
    column I18n.t('admin.authors') do |book|
      ul do
        book.authors.each do |author|
          li do
            link_to author.to_s, admin_author_path(author)
          end
        end
      end
    end
    column I18n.t('admin.categories') do |book|
      ul do
        book.categories.each do |category|
          li do
            link_to category.title.to_s, admin_category_path(category)
          end
        end
      end
    end
    actions
  end

  index as: :grid, columns: 5, default: true do |book|
    a href: admin_book_path(book) do
      if book.images.attached?
        img src: image_path(url_for(book.images.first.variant(resize: '150x250!'))), alt: book.images.first.name
      else
        img src: image_path(url_for('no_cover.jpg')), height: '250!'
      end
      div book.title
      book.authors.each do |author|
        div author.to_s
      end
    end
  end

  action_item :del_images, only: :show do
    link_to I18n.t('admin.delete_all_img'), images_admin_book_path(book), method: :put if book.images.attached?
  end

  member_action :images, method: :put do
    book = Book.find(params[:id])
    book.images.purge_later
    redirect_to admin_book_path(book)
  end
  member_action :delimg, method: :put do
    book = Book.find(params[:id])
    book.images.find(params[:img_id]).purge
    redirect_to admin_book_path(book)
  end

  show do
    attributes_table do
      row :title
      row I18n.t('admin.authors') do |book|
        ul do
          book.authors.each do |author|
            li do
              author.to_s
            end
          end
        end
      end
      row I18n.t('admin.categories') do |book|
        ul do
          book.categories.each do |category|
            li do
              category.title.to_s
            end
          end
        end
      end
      row :price
      row :quantity
      row :published_at
      row :description
      row :materials
      row I18n.t('admin.dimensions'), &:properties
      row :created_at
      row :updated_at
      row I18n.t('admin.images') do
        if book.images.attached?
          ul do
            book.images.each do |img|
              li do
                a href: url_for(img) do
                  img src: image_path(url_for(img.variant(resize: '100x200'))), alt: img.filename
                  div link_to "#{I18n.t('admin.delete_img')} #{img.filename}", \
                              delimg_admin_book_path(id: book, img_id: img.id), method: :put
                  div '-----------------------------'
                end
              end
            end
          end
        else
          content_tag(:span, I18n.t('admin.cover_not'))
        end
      end
    end
  end

  filter :title
  filter :price
  filter :quantity
  filter :published_at
  filter :authors
  filter :categories
  filter :created_at
  filter :updated_at

  form(html: { multipart: true }) do |f|
    f.inputs I18n.t('admin.info_book') do
      f.input :title
      f.input :description
      f.input :published_at
      f.input :quantity
      f.input :price
      f.input :materials
    end
    f.inputs I18n.t('admin.dimensions') do
      f.input :height
      f.input :width
      f.input :depth
    end
    f.inputs I18n.t('admin.categories') do
      f.input :category_ids, as: :check_boxes, collection: Category.all.map { |category| [category.title, category.id] }
    end
    f.inputs I18n.t('admin.authors') do
      f.input :author_ids, as: :check_boxes, collection: Author.all.map { |author| [author.to_s, author.id] }
    end
    f.inputs I18n.t('admin.images') do
      f.input :images, as: :file, input_html: { multiple: true }
    end
    f.actions
  end
  config.sort_order = AdminConst::TITLE_ASC
end
