FactoryBot.define do
  factory :flashcard_master do
    use_image { false }
    status { true }
    association :user
  end
end
