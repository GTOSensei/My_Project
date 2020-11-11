# frozen_string_literal: true

class OrdersFilterService
  def initialize(user, params)
    @user = user
    @params = params
  end

  def call
    return orders.accepted unless params_valid?

    orders.accepted.send(@params)
  end

  private

  def orders
    @user.orders
  end

  def params_valid?
    I18n.t('sort').include?(@params.try(:to_sym))
  end
end
