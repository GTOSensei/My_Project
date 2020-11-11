# frozen_string_literal: true

module AuthentificationAdmin
  def authenticate_active_admin_user!
    authenticate_user!
    return if current_user.admin?

    flash[:alert] = I18n.t('admin.unauthorized')
    redirect_to root_path
  end
end
