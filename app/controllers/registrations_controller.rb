# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def create
    return super if params[:user].key?('password')

    user = QuikRegisterService.new(email).call
    return redirect_to checkouts_path, alert: t('user.email_busy') if user.blank?
    return redirect_to checkouts_path, alert: user.errors.full_messages.join(', ') if user.errors.present?

    sign_in(:user, user)
    redirect_to checkouts_path, notice: t('user.send_email') + user.email
  end

  def update
    return super if type.blank?
    return redirect if AddressService.new(resource, address_params, type).call

    flash.now[:alert] = resource.send(type.to_sym).errors.full_messages.join(', ')
    render :edit
  end

  protected

  def redirect
    redirect_to edit_user_registration_path, notice: t('address.success')
  end

  def address_params
    params[:user][type].permit(:firstname, :lastname, :address, :city, :zip, :country_id, :phone)
  end

  def type
    params[:type]
  end

  def email
    params[:user][:email]
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, \
                                      keys: %i[email avatar password password_confirmation current_password])
  end

  def update_resource(resource, params)
    return super if params.key?(:password)

    resource.update_without_password(params)
  end

  def after_update_path_for(_resource)
    edit_user_registration_path
  end
end
