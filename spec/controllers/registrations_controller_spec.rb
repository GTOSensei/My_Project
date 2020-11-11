# frozen_string_literal: true

RSpec.describe RegistrationsController, type: :controller do
  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST #create QuikRegister' do
    let(:email) { FFaker::Internet.email }

    it 'successfull quick registration' do
      post :create, params: { user: { email: email } }
      user = User.find_by(email: email)
      sign_in(user, scope: :user)
      is_expected.to redirect_to(checkouts_path)
      expect(user).not_to be_nil
      is_expected.to set_flash[:notice].to(I18n.t('user.send_email') + email)
    end

    it { is_expected.to use_before_action(:configure_permitted_parameters) }
  end

  it 'email not entered' do
    post :create, params: { user: { email: nil } }
    is_expected.to redirect_to(checkouts_path)
    is_expected.to set_flash[:alert].to("Email can't be blank, Email is invalid")
  end

  it 'email busy' do
    email = FFaker::Internet.email
    user = QuikRegisterService.new(email).call
    post :create, params: { user: { email: email } }
    is_expected.to redirect_to(checkouts_path)
    expect(user.email).to eq(email)
    is_expected.to set_flash[:alert].to(I18n.t('user.email_busy'))
  end

  describe 'PUT #update addresses' do
    let(:user) { create(:user) }
    let(:address) do
      {
        billing_address: create(:billing_address, addressable: user),
        shipping_address: create(:shipping_address, addressable: user)
      }
    end
    before { sign_in(user, scope: :user) }

    it 'invalid billing_address' do
      put :update, params: { type: 'billing_address', user: { billing_address: BillingAddress.new.attributes } }
      is_expected.to render_template(:edit)
      expect(flash.now[:alert]).to eq("Address can't be blank, Address is invalid, Zip can't be blank, Zip is invalid, Phone can't be blank, Phone is invalid, Firstname can't be blank, Firstname is invalid, Lastname can't be blank, Lastname is invalid, City can't be blank, City is invalid")
    end

    it 'valid addresses' do
      address.each do |type, address|
        put :update, params: { type: type, user: { type => address.attributes } }
        is_expected.to redirect_to(edit_user_registration_path)
        is_expected.to set_flash[:notice].to(I18n.t('address.success'))
      end
    end

    it 'permit was called with the correct arguments' do
      is_expected.to permit(:firstname, :lastname, :address, :city, :zip, :country_id, :phone)
        .for(:update, params: { type: 'billing_address', user: { billing_address: BillingAddress.new.attributes } })
    end
  end
end
