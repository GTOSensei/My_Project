# frozen_string_literal: true

require 'ffaker'

15.times do
  Author.create!(firstname: FFaker::Name.first_name, lastname: FFaker::Name.last_name, \
                 biography: FFaker::Lorem.paragraph)
end

['Mobile Development', 'Web Development', 'Web Design', 'Photo'].each do |title|
  Category.create!(title: title)
end

materials = ['Genuine Leather', 'Artificial Leather', 'Designer Paper', 'Bung', 'Fabric Binding', \
             'Whole leather', 'Composite leather binding', 'Inlaid leather binding', 'Calico', 'Lederin']

30.times do
  book = Book.new(title: FFaker::Book.title, description: FFaker::Book.description, \
                  price: rand(3.5..100), quantity: rand(1..100), materials: materials[rand(0..9)], \
                  height: rand(0.1..6), width: rand(0.1..4), depth: rand(0.1..2), published_at: rand(2000..2018))
  book.dimensions = { height: book.height.round(2), width: book.width.round(2), depth: book.depth.round(2) }
  book.save!
end

5.times { User.create!(email: FFaker::Internet.email, password: FFaker::Internet.password) }
user = User.create!(email: 'admin@amazing.com', password: '12345678', admin: true)
user.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'avatar.jpg')), \
                   filename: 'avatar.jpg', content_type: 'image/jpg')

Book.all.each do |book|
  Category.all[rand(0..3)].books << book
  rand(1..3).times { book.authors << Author.all[rand(0..14)] }
  rand(1..4).times do
    book.reviews.create!(title: FFaker::Job.title, comment: FFaker::Lorem.sentence(5), \
                         rating: rand(1..5), status: Review.statuses.keys[rand(0..2)], user_id: rand(1..6))
  end
  # file = URI.parse(FFaker::Avatar.image).open
  # 4.times do
  #   book.images.attach(io: file, filename: file.to_s, content_type: 'image/png')
  # end
end

Coupon.create!(code: 'BLACK-555', discount: 100)
Coupon.create!(code: 'AMAZING', discount: 50)
Coupon.create!(code: '666666', discount: 25)

Delivery.create!(name: 'DHL Global', terms: '1 to 5 day', price: 50)
Delivery.create!(name: 'UPS', terms: '1 to 5 day', price: 55)
Delivery.create!(name: 'DELIVERY', terms: '2 to 7 day', price: 30)
Delivery.create!(name: 'IN TIME', terms: '2 to 10 day', price: 22)

Country.create!(name: 'Ukraine', phone_code: '+380')
7.times { Country.create!(name: FFaker::Address.country, phone_code: FFaker::PhoneNumber.phone_calling_code) }

user.create_billing_address(firstname: 'Alex', lastname: 'Doe', address: 'Kirova 112', \
                            city: 'Dnipro', zip: '49000', phone: '+380972293095', country_id: 1)
user.create_shipping_address(firstname: 'Nikita', lastname: 'John', address: 'Pobeda 36', \
                             city: 'Kiev', zip: '49000', phone: '+380675423870', country_id: 1)

User.all.each do |u|
  rand(1..3).times do
    number = "R#{Array.new(8) { [*'0'..'9'].sample }.join}"
    u.orders.create!(order_number: number, delivery: Delivery.all[rand(0..3)], coupon: Coupon.all[rand(0..2)])
  end
  u.orders.create!(order_number: "R#{Array.new(8) { [*'0'..'9'].sample }.join}", delivery: Delivery.all[rand(0..3)])
end

Order.all.each do |order|
  book = Book.all[rand(0..29)]
  quantity = rand(1..30)
  sub_total = book.price * quantity
  order.order_items.create!(price: book.price, quantity: quantity, sub_total: sub_total, book: book)
  order.create_billing_address(firstname: 'Alex', lastname: 'Doe', address: 'Kirova 112', \
                               city: 'Dnipro', zip: '49000', phone: '+380972293095', country_id: 1)
  order.create_shipping_address(firstname: 'Nikita', lastname: 'John', address: 'Pobeda 36', \
                                city: 'Kiev', zip: '49000', phone: '+380675423870', country_id: 1)
  order.create_credit_card(number: rand(1000..9999), card_owner: FFaker::NameDE.name, expiry_date: '12/20')
  discount = order.coupon.blank? ? 0 : order.coupon.discount
  total = sub_total - discount + order.delivery.price
  order.update(total_price: total, status: Order.statuses.keys[rand(1..4)])
end

Order.create!(order_number: "R#{Array.new(8) { [*'0'..'9'].sample }.join}")
Order.create!(order_number: "R#{Array.new(8) { [*'0'..'9'].sample }.join}")
Order.create!(order_number: "R#{Array.new(8) { [*'0'..'9'].sample }.join}")
