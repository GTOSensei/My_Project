# frozen_string_literal: true

RSpec.describe Category, type: :model do
  context 'db columns' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
  end

  context 'relations' do
    it { is_expected.to have_many(:book_categories).dependent(:destroy) }
    it { is_expected.to have_many(:books).through(:book_categories) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end
end
