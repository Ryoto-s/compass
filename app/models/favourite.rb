class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :word_book_master
end
