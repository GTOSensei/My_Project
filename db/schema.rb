# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_181_022_120_402) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'active_admin_comments', force: :cascade do |t|
    t.string 'namespace'
    t.text 'body'
    t.string 'resource_type'
    t.bigint 'resource_id'
    t.string 'author_type'
    t.bigint 'author_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[author_type author_id], name: 'index_active_admin_comments_on_author_type_and_author_id'
    t.index ['namespace'], name: 'index_active_admin_comments_on_namespace'
    t.index %w[resource_type resource_id], name: 'index_active_admin_comments_on_resource_type_and_resource_id'
  end

  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness', unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.bigint 'byte_size', null: false
    t.string 'checksum', null: false
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'addresses', force: :cascade do |t|
    t.string 'firstname'
    t.string 'lastname'
    t.string 'address'
    t.string 'city'
    t.string 'zip'
    t.string 'phone'
    t.string 'type'
    t.string 'addressable_type'
    t.bigint 'addressable_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'country_id'
    t.index %w[addressable_id addressable_type], name: 'index_addresses_on_addressable_id_and_addressable_type'
    t.index %w[addressable_type addressable_id], name: 'index_addresses_on_addressable_type_and_addressable_id'
    t.index ['country_id'], name: 'index_addresses_on_country_id'
  end

  create_table 'author_books', force: :cascade do |t|
    t.bigint 'author_id'
    t.bigint 'book_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['author_id'], name: 'index_author_books_on_author_id'
    t.index ['book_id'], name: 'index_author_books_on_book_id'
  end

  create_table 'authors', force: :cascade do |t|
    t.string 'firstname'
    t.string 'lastname'
    t.text 'biography'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'book_categories', force: :cascade do |t|
    t.bigint 'book_id'
    t.bigint 'category_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['book_id'], name: 'index_book_categories_on_book_id'
    t.index ['category_id'], name: 'index_book_categories_on_category_id'
  end

  create_table 'books', force: :cascade do |t|
    t.string 'title'
    t.text 'description'
    t.decimal 'price', precision: 6, scale: 2
    t.integer 'quantity'
    t.string 'materials'
    t.text 'dimensions'
    t.integer 'published_at'
    t.integer 'order_items_count', default: 0, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'categories', force: :cascade do |t|
    t.string 'title'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['title'], name: 'index_categories_on_title', unique: true
  end

  create_table 'countries', force: :cascade do |t|
    t.string 'name'
    t.string 'phone_code'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_countries_on_name', unique: true
    t.index ['phone_code'], name: 'index_countries_on_phone_code', unique: true
  end

  create_table 'coupons', force: :cascade do |t|
    t.string 'code'
    t.integer 'discount'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'credit_cards', force: :cascade do |t|
    t.string 'number'
    t.string 'card_owner'
    t.string 'expiry_date'
    t.bigint 'order_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['order_id'], name: 'index_credit_cards_on_order_id'
  end

  create_table 'deliveries', force: :cascade do |t|
    t.string 'name'
    t.text 'terms'
    t.decimal 'price', precision: 6, scale: 2
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'order_items', force: :cascade do |t|
    t.decimal 'price', precision: 8, scale: 2, default: '0.0', null: false
    t.integer 'quantity', default: 0, null: false
    t.decimal 'sub_total', precision: 8, scale: 2, default: '0.0', null: false
    t.bigint 'book_id'
    t.bigint 'order_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['book_id'], name: 'index_order_items_on_book_id'
    t.index ['order_id'], name: 'index_order_items_on_order_id'
  end

  create_table 'orders', force: :cascade do |t|
    t.string 'order_number'
    t.decimal 'total_price', precision: 10, scale: 2, default: '0.0', null: false
    t.integer 'status', default: 0, null: false
    t.bigint 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'delivery_id'
    t.bigint 'coupon_id'
    t.index ['coupon_id'], name: 'index_orders_on_coupon_id'
    t.index ['delivery_id'], name: 'index_orders_on_delivery_id'
    t.index ['order_number'], name: 'index_orders_on_order_number', unique: true
    t.index ['user_id'], name: 'index_orders_on_user_id'
  end

  create_table 'reviews', force: :cascade do |t|
    t.string 'title'
    t.text 'comment'
    t.integer 'rating'
    t.integer 'status', default: 0, null: false
    t.bigint 'book_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'user_id'
    t.index ['book_id'], name: 'index_reviews_on_book_id'
    t.index ['user_id'], name: 'index_reviews_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.boolean 'admin', default: false, null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.inet 'current_sign_in_ip'
    t.inet 'last_sign_in_ip'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'provider'
    t.string 'uid'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'addresses', 'countries'
  add_foreign_key 'author_books', 'authors'
  add_foreign_key 'author_books', 'books'
  add_foreign_key 'book_categories', 'books'
  add_foreign_key 'book_categories', 'categories'
  add_foreign_key 'orders', 'coupons'
  add_foreign_key 'orders', 'deliveries'
  add_foreign_key 'orders', 'users'
  add_foreign_key 'reviews', 'books'
  add_foreign_key 'reviews', 'users'
end
