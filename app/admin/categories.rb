# frozen_string_literal: true

ActiveAdmin.register Category do
  menu priority: 4

  permit_params :title

  filter :title
  filter :created_at
  filter :updated_at

  config.sort_order = AdminConst::TITLE_ASC
end
