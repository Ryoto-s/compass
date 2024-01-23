class FlashcardMasterResource
  include Alba::Resource
  attributes :id, :user_id, :use_image, :status

  # one :flashcard_images, resource: FlashcardResource
  one :flashcard_definition, resource: FlashcardDefinitionResource
  # many :results, resource: ResultResource
  # many :favourites, resource: FavouriteResource
  # many :tag_references, resource: TagReferenceResource
end
