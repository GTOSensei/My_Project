# frozen_string_literal: true

RSpec.describe AuthorBook, type: :model do
  context 'db columns' do
    it { is_expected.to have_db_column(:author_id).of_type(:integer) }
    it { is_expected.to have_db_column(:book_id).of_type(:integer) }
  end

  context 'relations' do
    it { is_expected.to belong_to(:author) }
    it { is_expected.to belong_to(:book) }
  end
end
