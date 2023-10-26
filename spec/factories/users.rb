FactoryBot.define do
  factory :user_default, class: User do
    email { 'immanuel.kant@example.com' }
    encrypted_password { '$2a$12$sUcxZqrOFFpdTS79WheM5u9ym4cbyX3kfexzzfbzfAqcIGBGVyuV2' }
    sign_in_count { 1 }
    last_sign_in_at { Date.parse('2023/09/30') }
    jti { '06d5a74b-f537-43ba-8995-0c94e0593a51' }
  end

  factory :user_random, class: User do
    email { Faker::Internet.email(separators: ['.'], domain: 'example.com') }
    encrypted_password { 'password_second' }
    sign_in_count { Faker::Number.within(range: 1..10) }
    last_sign_in_at { Date.parse('2022/03/31') }
  end
end
