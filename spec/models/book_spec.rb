# frozen_string_literal: true

RSpec.describe Book, type: :model do
  context 'db columns' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:price).of_type(:decimal) }
    it { is_expected.to have_db_column(:quantity).of_type(:integer) }
    it { is_expected.to have_db_column(:materials).of_type(:string) }
    it { is_expected.to have_db_column(:dimensions).of_type(:text) }
    it { is_expected.to have_db_column(:published_at).of_type(:integer) }
    it { is_expected.to have_db_column(:order_items_count).of_type(:integer) }
  end

  context 'relations' do
    it { is_expected.to have_many(:author_books).dependent(:destroy) }
    it { is_expected.to have_many(:authors).through(:author_books) }
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
    it { is_expected.to have_many(:book_categories).dependent(:destroy) }
    it { is_expected.to have_many(:categories).through(:book_categories) }
    it { is_expected.to have_many(:order_items).dependent(:destroy) }
  end

  context 'validations' do
    %i[title dimensions description materials].each do |field|
      it { is_expected.to validate_presence_of(field) }
    end
    %i[price height width depth].each do |field|
      it { is_expected.to validate_numericality_of(field).is_greater_than_or_equal_to(0.01) }
    end
    it { is_expected.to validate_numericality_of(:quantity).only_integer }
    it { is_expected.to validate_numericality_of(:published_at).is_less_than_or_equal_to(Date.current.year) }
  end

  context 'Attachments' do
    it 'is valid book images' do
      subject.images.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'no_cover.jpg')), \
                            filename: 'no_cover.jpg', content_type: 'image/jpg')
      expect(subject.images).to be_attached
    end
  end
end
