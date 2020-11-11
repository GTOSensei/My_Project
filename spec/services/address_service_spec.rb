# frozen_string_literal: true

RSpec.describe AddressService do
  let(:order) { create(:order) }
  let(:user) { order.user }
  let(:country) { create(:country) }
  let(:params) do
    {
      firstname: 'Alex',
      lastname: 'Doe',
      address: 'Aliza Court',
      city: 'Dnipro',
      zip: '49000',
      phone: "#{country.phone_code}123456789",
      country_id: country.id
    }
  end

  [AddressConst::BILLING, AddressConst::SHIPPING].each do |type|
    it "returns nil if the user’s #{type} is not created" do
      expect(user.send(type.to_sym)).to eq(nil)
    end

    it "returns nil if the order’s #{type} is not created" do
      expect(order.send(type.to_sym)).to eq(nil)
    end

    it "returns true if the user’s #{type} was successfully created" do
      expect(AddressService.new(user, params, type).call).to be true
    end

    it "returns true if the order’s #{type} was successfully created" do
      expect(AddressService.new(order, params, type).call).to be true
    end

    it "compares user #{type} fields with params fields" do
      AddressService.new(user, params, type).call
      params.each do |field, value|
        expect(user.send(type.to_sym)[field]).to eq(value)
      end
    end

    it "compares order #{type} fields with params fields" do
      AddressService.new(order, params, type).call
      params.each do |field, value|
        expect(order.send(type.to_sym)[field]).to eq(value)
      end
    end

    it "returns false if the user’s #{type} was not valid" do
      params[:phone] = 'number ove'
      expect(AddressService.new(user, params, type).call).to be false
    end

    it "returns false if the order’s #{type} was not valid" do
      params[:zip] = 'zip_code'
      expect(AddressService.new(order, params, type).call).to be false
    end
  end
end
