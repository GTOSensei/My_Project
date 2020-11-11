# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :admin, :avatar

  action_item :del_avatar, only: :show do
    link_to I18n.t('admin.del_avatar'), avatar_admin_user_path(user), method: :put if user.avatar.attached?
  end

  member_action :avatar, method: :put do
    user = User.find(params[:id])
    user.avatar.purge
    redirect_to admin_user_path(user)
  end

  index do
    selectable_column
    id_column
    column I18n.t('admin.avatar') do |user|
      if user.avatar.attached?
        image_tag(user.avatar.variant(resize: '100x100!'))
      else
        image_tag('no_avatar.png')
      end
    end
    column :email do |user|
      link_to user.email, [:admin, user]
    end
    column :admin
    column :sign_in_count
    column :current_sign_in_at
    actions
  end

  show do
    attributes_table do
      row :avatar do |user|
        if user.avatar.attached?
          image_tag(user.avatar.variant(resize: '100x100!'))
        else
          image_tag('no_avatar.png')
        end
      end
      row :email
      row :admin
      row :sign_in_count
      row :reset_password_token
      row :reset_password_sent_at
      row :remember_created_at
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :confirmation_token
      row :confirmed_at
      row :confirmation_sent_at
      row :unconfirmed_email
      row :created_at
      row :updated_at
    end
  end

  filter :email
  filter :admin
  filter :current_sign_in_at
  filter :sign_in_count, as: :numeric
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :admin
      f.input :password
      f.input :password_confirmation
    end
    f.inputs I18n.t('admin.user_photo') do
      f.input :avatar, as: :file, input_html: { multiple: false }
    end
    f.actions
  end
  config.sort_order = AdminConst::CREATED_ASC
end
