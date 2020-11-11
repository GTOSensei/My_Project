# frozen_string_literal: true

RSpec.describe QuikRegisterService do
  context 'user object is created' do
    let(:email) { 'rspec@service.com' }
    let(:user) { QuikRegisterService.new(email).call }

    it 'returns true if user created' do
      expect(user.valid?).to be true
    end
    it 'checks if user email is same' do
      expect(user.email).to eq(email)
    end
    it 'checks if password is empty' do
      expect(user.password.present?).to be true
    end
    it 'checks if user is not an admin' do
      expect(user.admin).to eq(false)
    end
  end

  it 'returns false if email not valid' do
    email = '4343543service.com'
    expect(QuikRegisterService.new(email).call.valid?).to be false
  end

  it 'returns nil if email address is already in use' do
    user = create(:user)
    expect(QuikRegisterService.new(user.email).call).to be nil
  end
end
