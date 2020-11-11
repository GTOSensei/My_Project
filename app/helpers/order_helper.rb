# frozen_string_literal: true

module OrderHelper
  def order_sort_by
    I18n.t('sort').fetch(filter.to_sym)
  end

  def status(status)
    I18n.t('sort').fetch(status.to_sym)
  end

  def order_total_count
    current_order.blank? ? 0 : current_order.total_count
  end

  private

  def filter
    I18n.t('sort')[params[:filter].try(:to_sym)] ? params[:filter] : 'all'
  end
end
