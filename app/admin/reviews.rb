# frozen_string_literal: true

ActiveAdmin.register Review do
  menu priority: 6
  permit_params :title, :comment, :rating, :status, :book, :user, :book_id, :user_id

  actions :index, :show, :destroy

  books = -> { Book.all.map { |book| [book.title, book.id] } }
  users = -> { User.all.map { |user| [user.email, user.id] } }

  scope I18n.t('admin.all'), :all
  scope I18n.t('admin.new'), :unprocessed, default: true
  scope I18n.t('admin.processed'), :others_status

  action_item :approved, only: :show do
    link_to I18n.t('admin.approved'), approved_admin_review_path(review), method: :put
  end
  action_item :rejected, only: :show do
    link_to I18n.t('admin.rejected'), rejected_admin_review_path(review), method: :put
  end
  action_item :back, only: :show do
    link_to I18n.t('admin.back_review'), admin_reviews_path
  end

  member_action :approved, method: :put do
    review = Review.find(params[:id])
    review.approved!
    redirect_to admin_review_path(review)
  end
  member_action :rejected, method: :put do
    review = Review.find(params[:id])
    review.rejected!
    redirect_to admin_review_path(review)
  end

  index do
    selectable_column
    id_column
    column :book
    column I18n.t('admin.title_review') do |review|
      link_to review.title, admin_review_path(review)
    end
    column :created_at
    column :user
    column :status
    actions
  end

  filter :book, collection: books
  filter :user, collection: users
  filter :status, as: :select, collection: Review.statuses
  filter :rating, as: :check_boxes, collection: 0..5
  filter :created_at

  config.sort_order = AdminConst::CREATED_DESC
end
