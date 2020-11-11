# frozen_string_literal: true

RSpec.describe BookCategory, type: :model do
  context 'db columns' do
    it { is_expected.to have_db_column(:category_id).of_type(:integer) }
    it { is_expected.to have_db_column(:book_id).of_type(:integer) }
  end

  context 'relations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:book) }
  end
end
