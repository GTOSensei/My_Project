# frozen_string_literal: true

ActiveAdmin.register Coupon do
  menu priority: 7
  permit_params :code, :discount

  index do
    selectable_column
    column :code
    column :discount
    actions
  end

  filter :code
  filter :discount

  config.sort_order = AdminConst::CREATED_ASC
end
