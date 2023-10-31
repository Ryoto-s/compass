class WordBookMaster < ApplicationRecord
  belongs_to :user
  has_many :word_definitions
  has_many :results
  has_many :favourites
  has_one :word_image
  has_many :tag_references
  has_many :tags, through: :tag_references
end
