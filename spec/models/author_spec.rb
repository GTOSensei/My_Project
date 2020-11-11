# frozen_string_literal: true

RSpec.describe Author, type: :model do
  context 'db columns' do
    it { is_expected.to have_db_column(:firstname).of_type(:string) }
    it { is_expected.to have_db_column(:lastname).of_type(:string) }
    it { is_expected.to have_db_column(:biography).of_type(:text) }
  end

  context 'relations' do
    it { is_expected.to have_many(:author_books).dependent(:destroy) }
    it { is_expected.to have_many(:books).through(:author_books) }
  end

  context 'validations' do
    %i[firstname lastname].each do |field|
      it { is_expected.to validate_presence_of(field) }
    end
  end
end
