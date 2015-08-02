# This will guess the User class
FactoryGirl.define do
  factory :user do
    name 'Example User'
    sequence(:email) { |n| "person-#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
  end

  factory :product do
    name 'Product'
    image 'http://s.hswstatic.com/gif/hammer-1.jpg'
  end

  factory :product_auction do
    value 100
  end
end
