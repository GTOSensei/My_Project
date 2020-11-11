# frozen_string_literal: true

class CheckoutService
  include AddressConst

  def initialize(user, order, params, step)
    @user = user
    @order = order
    @params = params
    @step = step
  end

  def call
    send("create_#{@step}".to_sym)
  end

  private

  def create_address
    billing = AddressService.new(@order, address_params(BILLING), BILLING).call
    shipping = AddressService.new(@order, address_params(address_type), SHIPPING).call
    billing && shipping
  end

  def create_delivery
    delivery = Delivery.find_by(id: @params[:order][:delivery_id])
    delivery.blank? ? false : @order.update(delivery: delivery)
  end

  def create_payment
    return @order.credit_card.update(paymant_params) if @order.credit_card.present?

    @order.create_credit_card(paymant_params).valid?
  end

  def create_confirm
    result = @order.update(total_price: @order.order_total)
    OrderMailer.info_about_order(@user, @order).deliver_now if result
    result
  end

  def address_type
    use_billing? ? BILLING : SHIPPING
  end

  def address_params(type)
    @params[:order][type].permit(:firstname, :lastname, :address, :city, :zip, :country_id, :phone)
  end

  def paymant_params
    paymant = @params[:order][:credit_card].permit(:number, :card_owner, :expiry_date)
    paymant[:number] = paymant[:number].last(4)
    paymant
  end

  def use_billing?
    @order.use_billing = @params[:order][:use_billing] == '1'
  end
end
