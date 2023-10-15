class TagReference < ApplicationRecord
  belongs_to :word_book_master
  belongs_to :tag
end
