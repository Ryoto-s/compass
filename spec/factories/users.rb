FactoryBot.define do
  factory :user do
    association :account
    status { true }
  end

  factory :user_default, parent: :user, class: User do
    first_name { 'Immanuel' }
    sur_name { 'Kant' }
    first_phonetic { 'いまぬえる' }
    sur_phonetic { 'かんと' }
    date_of_birth { Date.parse('1724/04/22') }
    sex { 'm' }
  end

  factory :user_random, parent: :user, class: User do
    first_name { Faker::Name.first_name }
    sur_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.birthday(min_age: 15, max_age: 90) }
    sex { Faker::Gender.short_binary_type }
  end
end
