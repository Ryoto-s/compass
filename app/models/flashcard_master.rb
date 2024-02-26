class FlashcardMaster < ApplicationRecord
  belongs_to :user
  has_one :flashcard_definition, dependent: :destroy
  has_many :results, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_one :flashcard_image, dependent: :destroy
  has_many :tag_references
  has_many :tags, through: :tag_references

  accepts_nested_attributes_for :flashcard_definition, allow_destroy: true
  enum :status, { enabled: true, disabled: false }
  enum :shared_flag, { private_card: 0, friends_only: 1, public_card: 2 }

  def latest_result
    results.order(updated_at: :desc).first
  end
end
