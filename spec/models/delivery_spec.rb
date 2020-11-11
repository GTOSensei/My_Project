# frozen_string_literal: true

RSpec.describe Delivery, type: :model do
  context 'db columns' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:terms).of_type(:text) }
    it { is_expected.to have_db_column(:price).of_type(:decimal).with_options(precision: 6, scale: 2) }
  end

  context 'relations' do
    it { is_expected.to have_many(:orders).dependent(:nullify) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name).with_message(I18n.t('errors.delivery')) }
    it { is_expected.to validate_presence_of(:terms).with_message(I18n.t('errors.terms')) }
    it {
      is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0.00)
                                                     .with_message(I18n.t('errors.price'))
    }
  end
end
