class FlashcardImage < ApplicationRecord
  belongs_to :flashcard_master

  mount_uploader :image, ImageUploader
end
