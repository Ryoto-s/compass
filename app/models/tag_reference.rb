class TagReference < ApplicationRecord
  belongs_to :flashcard_master
  belongs_to :tag
end
