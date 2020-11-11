# frozen_string_literal: true

class FilterCheckoutsService
  include CheckoutConst

  def initialize(user, order, params)
    @user = user
    @order = order
    @step = params[:id].to_sym
    @edit = params[:edit]
  end

  def call
    @order.in_queue! if complete?
    { redirect: step_redirect, render: step_render }
  end

  private

  def step_redirect
    @step_redirect ||= payment || delivery || address || login
  end

  def step_render
    @step if step_redirect == @step || edit? || complete?
  end

  def edit?
    @edit && payment && delivery && address
  end

  def complete?
    return false if @order.credit_card.blank?

    @step == COMPLETE
  end

  def payment
    CONFIRM if @order.credit_card.present?
  end

  def delivery
    PAYMENT if @order.delivery.present?
  end

  def address
    DELIVERY if @order.billing_address.present? && @order.shipping_address.present?
  end

  def login
    @user.present? ? ADDRESS : LOGIN
  end
end
