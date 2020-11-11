# frozen_string_literal: true

RSpec.describe 'Settings page', type: :feature do
  let(:user) { create(:user) }
  let!(:country) { create(:country, name: 'Ukraine', phone_code: '+380') }
  before :each do
    login_as user
    visit edit_user_registration_path
  end

  [I18n.t('devise.address'), I18n.t('devise.privacy')].each do |link_name|
    it "have link '#{link_name}'" do
      expect(find('ul.nav.clearfix.mb-20')).to have_link(link_name)
    end
  end

  [I18n.t('devise.settings'), I18n.t('address.billing_address'), I18n.t('address.shipping_address')].each do |content|
    it { expect(page).to have_content(content) }
  end

  context 'tab Address' do
    { billing_address: '.col-md-5.mb-40', shipping_address: '.col-md-5.col-md-offset-1.mb-25' }.each do |type, div|
      it "valid #{type}" do
        within(div) do
          fill_in("user[#{type}][firstname]", with: 'Alex')
          fill_in("user[#{type}][lastname]", with: 'Doe')
          fill_in("user[#{type}][address]", with: 'Kirova 112')
          fill_in("user[#{type}][city]", with: 'Dnipro')
          fill_in("user[#{type}][zip]", with: '49000')
          fill_in("user[#{type}][phone]", with: '+380975559999')
          select(country.name, from: "user[#{type}][country_id]")
          click_button(I18n.t('button.save'))
        end
        expect(page).to have_content I18n.t('address.success')
      end

      it "invalid #{type}" do
        within(div) { click_button(I18n.t('button.save')) }
        expect(page).to have_content "Address can't be blank, Address is invalid, Zip can't be blank, Zip is invalid, Phone can't be blank, Phone is invalid, Firstname can't be blank, Firstname is invalid, Lastname can't be blank, Lastname is invalid, City can't be blank, City is invalid"
        expect(all('.form-group.has-error>span.help-block').count).to eq(6)
      end
    end
  end

  context 'tab Privacy' do
    before:each do
      click_link I18n.t('devise.privacy')
    end

    [I18n.t('devise.email'), I18n.t('devise.password'), I18n.t('devise.remove_account')].each do |content|
      it { expect(page).to have_content(content) }
    end

    it { expect(find_field('user[email]').value).to have_content(user.email) }

    it 'change email' do
      within('.general-form-md') do
        fill_in('user[email]', with: 'capybara@amazing.com')
        attach_file('user[avatar]', Rails.root.join('app', 'assets', 'images', 'avatar.jpg'))
        click_button(I18n.t('button.save'))
      end
      expect(find_field('user[email]').value).to have_content('capybara@amazing.com')
      expect(page).to have_css("img[src*='avatar.jpg']")
      expect(page).to have_content I18n.t('devise.registrations.updated')
    end

    it "button '#{I18n.t('devise.remove_my_account')}' disabled" do
      expect(find_button(I18n.t('devise.remove_my_account'), disabled: true)[:disabled]).to eq 'disabled'
    end

    it "button '#{I18n.t('devise.remove_my_account')}' disabled", js: true do
      within('.col-sm-12') do
        find('span.checkbox-icon').click
        click_button(I18n.t('devise.remove_my_account'))
      end
      page.driver.browser.switch_to.alert.accept
      alert = page.driver.browser.switch_to.alert
      expect(alert.text).to eq(I18n.t('devise.are_you_sure'))
      alert.accept
      expect(page).to have_content('Bye! Your account has been successfully cancelled. We hope to see you again soon.')
      expect(page).to have_current_path(root_path)
    end

    it 'successful password change', js: true do
      within('.col-sm-5.col-sm-offset-1') do
        fill_in('user[current_password]', with: user.password)
        fill_in('user[password]', with: '12345678')
        fill_in('user[password_confirmation]', with: '12345678')
        click_button(I18n.t('button.save'))
      end
      expect(page).to have_content I18n.t('devise.registrations.updated')
    end

    it 'invalid password' do
      within('.col-sm-5.col-sm-offset-1') { find_button(I18n.t('button.save'), disabled: true).click }
      expect(page).to have_content "1 error prohibited this user from being saved: Current password can't be blank"
    end
  end
end
