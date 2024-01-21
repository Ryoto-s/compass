FactoryBot.define do
  factory :result, parent: :flashcard_master do
    learned_at { '2023/09/30' }
    result { true }
  end
end
