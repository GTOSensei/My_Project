# frozen_string_literal: true

ActiveAdmin.register Author do
  menu priority: 3
  permit_params :firstname, :lastname, :biography

  index do
    selectable_column
    id_column
    column I18n.t('admin.author') do |author|
      link_to author.to_s, admin_author_path(author)
    end
    column :created_at
    actions
  end

  filter :firstname
  filter :lastname
  filter :created_at
  filter :updated_at
end
