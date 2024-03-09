class HomeController < BaseController
  # All data included
  def index
    query_results = FlashcardMaster.enabled.where(user_id: current_user.id)
                                   .joins(:flashcard_definition)
                                   .eager_load(:favourites)
                                   .preload(:flashcard_image)
                                   .order(created_at: :asc)
    if query_results.empty?
      render status: :no_content
      nil
    else
      flashcard_masters = query_results.map do |q|
        # Flashcard can be shared with other users, hence it can be associated with multiple favourites,
        # creating a many-to-many relationship defined by a unique combination of user_id and flashcard_master_id.
        # Here, since favourites are filtered by user_id, retrieve only the first favourite record.
        favourite = q.favourites.first || Favourite.new
        {
          id: q.id,
          use_image: q.use_image,
          shared_flag: q.shared_flag,
          input_enabled: q.input_enabled,
          flashcard_definition: {
            id: q.flashcard_definition.id,
            word: q.flashcard_definition.word,
            answer: q.flashcard_definition.answer,
            language: q.flashcard_definition.language
          },
          flashcard_image: {
            image: q.flashcard_image.try(:image)
          },
          favourite: favourite.as_json(only: %i[id flashcard_master_id user_id]),
          latest_result: q.latest_result.as_json(only: %i[result updated_at])
        }
      end

      message = "Found #{flashcard_masters.size} flashcards for UserID: #{current_user.id}"
      render json: JSON.pretty_generate({ message:, flashcard_masters: flashcard_masters.as_json }), status: :ok
    end
  end
end
