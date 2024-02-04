class FlashcardMaster < ApplicationRecord
  belongs_to :user
  has_one :flashcard_definition
  has_many :results
  has_many :favourites
  has_one :flashcard_image
  has_many :tag_references
  has_many :tags, through: :tag_references

  accepts_nested_attributes_for :flashcard_definition, allow_destroy: true
  enum :status, { enabled: true, disabled: false }
  enum :shared_flag, { private_card: 0, friends_only: 1, public_card: 2 }
end
