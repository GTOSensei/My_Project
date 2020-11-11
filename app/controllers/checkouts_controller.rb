# frozen_string_literal: true

class CheckoutsController < ApplicationController
  include Wicked::Wizard
  include CheckoutConst

  before_action :authenticate_user!, only: :update
  before_action :current_data, only: %i[show update]

  steps LOGIN, ADDRESS, DELIVERY, PAYMENT, CONFIRM, COMPLETE

  def show
    return redirect_to root_path if @order.blank?

    filter = FilterCheckoutsService.new(@user, @order, params).call
    return redirect_to wizard_path(filter[:redirect]) if filter[:render].blank?

    render_wizard
  end

  def update
    return redirect_to wizard_path(next_step) if CheckoutService.new(@user, @order, params, step).call

    flash.now[:alert] = ErrorsService.new(@order, step).call
    render step
  end

  private

  def current_data
    @user = current_user
    @order = current_order
  end
end
