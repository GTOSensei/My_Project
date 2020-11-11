# frozen_string_literal: true

ActiveAdmin.register Delivery do
  menu priority: 8
  permit_params :name, :terms, :price

  index do
    selectable_column
    column :name
    column :terms
    column :price
    actions
  end

  filter :name
  filter :terms
  filter :price

  config.sort_order = AdminConst::NAME_ASC
end
