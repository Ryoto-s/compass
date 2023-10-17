FactoryBot.define do
  factory :word_book_master do
    use_image { false }
    status { true }
    association :user
  end
end
