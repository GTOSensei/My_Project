# frozen_string_literal: true

RSpec.describe CreditCard, type: :model do
  context 'db columns' do
    it { is_expected.to have_db_column(:number).of_type(:string) }
    it { is_expected.to have_db_column(:card_owner).of_type(:string) }
    it { is_expected.to have_db_column(:expiry_date).of_type(:string) }
    it { is_expected.to have_db_column(:order_id).of_type(:integer) }
  end

  context 'relations' do
    it { is_expected.to belong_to(:order) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:card_owner) }
    it { is_expected.to validate_length_of(:card_owner).is_at_most(RegexPayment::MAX) }
    it { is_expected.to validate_numericality_of(:expiry_date).with_message(I18n.t('errors.expiry_date')) }
  end
end
