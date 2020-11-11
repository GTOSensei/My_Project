# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthentificationAdmin
  protect_from_forgery prepend: true
  helper_method :current_order
  before_action :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  def current_order
    @current_order ||= FindOrderService.new(current_user, session[:order_id]).call
    session[:order_id] = nil if user_signed_in?
    @current_order
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
end
