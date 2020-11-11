# frozen_string_literal: true

RSpec.describe 'Book page', type: :feature do
  let(:book) { create(:book).decorate }
  before :each do
    visit book_path(book)
  end

  context 'checking content of book and link to add to cart' do
    it 'availability of book content' do
      [book.title, book.price, book.authors, book.published_at, book.materials,
       book.description, book.properties].each do |content|
        expect(page).to have_content(content)
      end
      expect(page).to have_css("img[alt*=#{book.cover[:name]}]")
    end

    it "add to cart button click #{I18n.t('button.add_to_cart')}", js: true do
      click_button(I18n.t('button.add_to_cart'))
      expect(find('header')).to have_content('1')
    end

    it "add to cart 7 books by cklick button #{I18n.t('button.add_to_cart')}", js: true do
      fill_in('quantity', with: '7')
      click_button(I18n.t('button.add_to_cart'))
      expect(find('header')).to have_content('7')
    end

    it 'click plus quantity book', js: true do
      first(:css, 'a.input-link.quantity-plus').click
      expect(find_field('quantity').value).to eq('2')
    end

    it 'click minus quantity book', js: true do
      fill_in('quantity', with: '4')
      first(:css, 'a.input-link.quantity-minus').click
      expect(find_field('quantity').value).to eq('3')
    end

    it { expect(page).to have_field('quantity', minimum: '1') }
  end

  context 'checking contents of reviews' do
    let(:reviews) { book.reviews.decorate }

    it 'availability Reviews (count)' do
      expect(find('h3.in-gold-500.mb-25')).to have_content("#{I18n.t('review.name')} (#{reviews.count})")
    end

    it 'availability of review content' do
      reviews.each do |review|
        [I18n.t('review.verified'), review.date, review.name, review.title, review.comment].each do |content|
          expect(page).to have_content(content)
        end
      end
    end

    it { expect(page).to have_css('span.img-circle.logo-size.inlide-block.pull-left.logo-empty') }

    it "have not button #{I18n.t('review.review')}" do
      expect(page).to have_no_button(I18n.t('review.review'))
    end

    %w[Title Review].each do |field|
      it "have not '#{field}'" do
        expect(page).to have_no_field(field)
      end
    end

    it { expect(page).to have_no_content(I18n.t('review.write')) }
    it { expect(page.has_css?('.star-rating__wrap')).to be false }
    it { expect(page).to have_no_content('Score') }
  end

  context 'writing a review when user is logged in' do
    let(:user) { create(:user) }
    before(:each) do
      login_as user
      visit book_path(book)
    end

    it "returns message: '#{I18n.t('review.msg')}'" do
      within('.mb-40') do
        fill_in 'review[title]', with: 'The best book'
        fill_in 'review[comment]', with: 'Buy will not regret'
      end
      find('.star-rating__wrap').choose('review[rating]', option: '5')
      click_button I18n.t('review.review')
      expect(page).to have_content I18n.t('review.msg')
      expect(page).to have_no_content 'The best book'
    end

    it 'invalid Title of review' do
      within('.mb-40') { fill_in 'review[comment]', with: 'Buy will not regret' }
      find('.star-rating__wrap').choose('review[rating]', option: '5')
      click_button I18n.t('review.review')
      expect(page).to have_content "Title is invalid, Title can't be blank"
    end

    it "message '#{I18n.t('review.rating_error')}'" do
      within('.mb-40') do
        fill_in 'review[title]', with: 'The best book'
        fill_in 'review[comment]', with: 'Buy will not regret'
      end
      click_button I18n.t('review.review')
      expect(find('#txt.err')).to have_content I18n.t('review.rating_error')
    end
  end
end
