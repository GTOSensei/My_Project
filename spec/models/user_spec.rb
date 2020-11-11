# frozen_string_literal: true

RSpec.describe User, type: :model do
  context 'db columns' do
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
    it { is_expected.to have_db_column(:admin).of_type(:boolean) }
    it { is_expected.to have_db_column(:provider).of_type(:string) }
    it { is_expected.to have_db_column(:uid).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
  end

  context 'relations' do
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
    it { is_expected.to have_one(:billing_address).dependent(:destroy) }
    it { is_expected.to have_one(:shipping_address).dependent(:destroy) }
    it { is_expected.to have_many(:orders).dependent(:destroy) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:email).is_at_most(63) }
    it { is_expected.to validate_length_of(:password).is_at_least(8) }
  end

  context 'Attachment' do
    it 'is valid user avatar' do
      subject.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'avatar.jpg')), \
                            filename: 'avatar.jpg', content_type: 'image/jpg')
      expect(subject.avatar).to be_attached
    end
  end
end
