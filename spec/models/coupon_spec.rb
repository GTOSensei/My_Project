# frozen_string_literal: true

RSpec.describe Coupon, type: :model do
  context 'db columns' do
    it { is_expected.to have_db_column(:code).of_type(:string) }
    it { is_expected.to have_db_column(:discount).of_type(:integer) }
  end

  context 'relations' do
    it { is_expected.to have_many(:orders).dependent(:destroy) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:code).with_message(I18n.t('errors.code')) }
    it { is_expected.to validate_numericality_of(:discount).only_integer.with_message(I18n.t('errors.discount')) }
  end
end
