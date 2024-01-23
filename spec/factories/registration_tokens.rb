FactoryBot.define do
  factory :registration_token do
    token { "MyString" }
    user { nil }
  end
end
