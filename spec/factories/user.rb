FactoryGirl.define do

  factory :user do
    email 'example@mail.com'
    password 'secret1234'
  end

  factory :confirmed_user, :parent => :user do
    after(:create) { |user| user.confirm! }
  end

end
