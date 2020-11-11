# frozen_string_literal: true

RSpec.describe Review, type: :model do
  context 'db columns' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:comment).of_type(:text) }
    it { is_expected.to have_db_column(:rating).of_type(:integer) }
    it { is_expected.to have_db_column(:status).of_type(:integer) }
    it { is_expected.to have_db_column(:book_id).of_type(:integer) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
  end

  context 'relations' do
    let(:statuses) { { unprocessed: 0, approved: 1, rejected: 2 } }
    it { is_expected.to define_enum_for(:status).with(statuses) }
    it { is_expected.to belong_to(:book) }
    it { is_expected.to belong_to(:user) }
  end

  context 'validations' do
    it {
      is_expected.to validate_numericality_of(:rating).only_integer
        .is_greater_than_or_equal_to(RegexReview::MIN_RATE)
                                                      .is_less_than_or_equal_to(RegexReview::MAX_RATE)
    }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:comment) }
    it { is_expected.to validate_length_of(:title).is_at_most(RegexReview::MAX_TITLE) }
    it { is_expected.to validate_length_of(:comment).is_at_most(RegexReview::MAX_COMMENT) }
  end
end
