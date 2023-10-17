FactoryBot.define do
  factory :result, parent: :word_book_master do
    learned_at { '2023/09/30' }
    result { true }
  end
end
