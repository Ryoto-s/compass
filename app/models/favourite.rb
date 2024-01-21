class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :flashcard_master
end
