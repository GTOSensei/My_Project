# frozen_string_literal: true

RSpec.describe ReviewDecorator do
  let(:review) { create(:review).decorate }
  let(:email) { review.user.email }

  describe '#logo' do
    it 'returns nil if avatar is missing' do
      expect(review.logo).to eq(nil)
    end
  end

  describe '#name' do
    it 'returns email name if there is no user name' do
      expect(email.capitalize).to match(review.name)
    end

    it 'returns full name user' do
      user = create(:user, :with_addresses)
      comment = create(:review, user: user).decorate
      expect(comment.name).to match(user.billing_address.firstname + ' ' + user.billing_address.lastname)
    end
  end

  describe '#date' do
    it "returns date in format '%Y/%m/%d'" do
      expect(review.date).to eq(review.created_at.strftime('%Y/%m/%d'))
    end
  end

  describe '#self.errors' do
    %i[title comment rating status book_id user_id].each do |field|
      it "returns false if '#{field}' field is valid" do
        expect(ReviewDecorator.errors(review, field)).to be false
      end
    end

    %i[title comment rating book user].each do |field|
      it "returns true if '#{field}' field is not valid" do
        rev = Review.create
        expect(ReviewDecorator.errors(rev, field)).to be true
      end
    end
  end
end
