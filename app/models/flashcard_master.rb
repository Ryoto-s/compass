class FlashcardMaster < ApplicationRecord
  belongs_to :user
  has_one :flashcard_definition
  has_many :results
  has_many :favourites
  has_one :flashcard_image
  has_many :tag_references
  has_many :tags, through: :tag_references
  has_one :card_image

  enum :status, { enabled: true, disabled: false }
end
