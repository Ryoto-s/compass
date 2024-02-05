class Result < ApplicationRecord
  belongs_to :flashcard_master

  enum :result, { correct: 0, intermediate: 1, incorrect: 2, not_sure: 3 }
end
