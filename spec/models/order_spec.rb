# frozen_string_literal: true

RSpec.describe Order, type: :model do
  context 'db columns' do
    it { is_expected.to have_db_column(:order_number).of_type(:string) }
    it { is_expected.to have_db_column(:total_price).of_type(:decimal).with_options(precision: 10, scale: 2) }
    it { is_expected.to have_db_column(:status).of_type(:integer) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:delivery_id).of_type(:integer) }
    it { is_expected.to have_db_column(:coupon_id).of_type(:integer) }
  end

  context 'relations' do
    let(:statuses) do
      { OrderConst::IN_PROGRESS => 0, OrderConst::IN_QUEUE => 1, OrderConst::IN_DELIVEY => 2,
        OrderConst::DELIVERED => 3, OrderConst::CANCELED => 4 }
    end
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to belong_to(:delivery).optional }
    it { is_expected.to belong_to(:coupon).optional }
    it { is_expected.to have_one(:credit_card).dependent(:destroy) }
    it { is_expected.to have_many(:order_items).dependent(:destroy) }
    it { is_expected.to have_one(:billing_address).dependent(:destroy) }
    it { is_expected.to have_one(:shipping_address).dependent(:destroy) }
    it { is_expected.to define_enum_for(:status).with(statuses) }
  end

  context 'validations' do
    it { is_expected.to validate_uniqueness_of(:order_number).case_insensitive }
    it { is_expected.to validate_numericality_of(:total_price).is_greater_than_or_equal_to(0.00) }
  end
end
