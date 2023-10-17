FactoryBot.define do
  factory :account_default, class: Account do
    email { Faker::Internet.email(name: 'Immanuel Kant', separators: ['.'], domain: 'example.com') }
    encrypted_password { 'password' }
    sign_in_count { 1 }
    last_sign_in_at { Date.parse('2023/09/30') }
  end

  factory :account_random, class: Account do
    email { Faker::Internet.email(separators: ['.'], domain: 'example.com') }
    encrypted_password { 'password_second' }
    sign_in_count { Faker::Number.within(range: 1..10) }
    last_sign_in_at { Date.parse('2022/03/31') }
  end
end
