class HomeController < BaseController
  # All data included
  def index
    query_results = FlashcardMaster.enabled.where(user_id: current_user.id)
    if query_results.empty?
      render json: { message: "Data not set. UserID: #{current_user.id}" }
    else
      flashcard_masters = query_results.map do |q|
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
          latest_result: q.latest_result.as_json(only: %i[result updated_at])
        }
      end

      message = "Found #{flashcard_masters.size} flashcards for UserID: #{current_user.id}"
      render json: JSON.pretty_generate({ message:, flashcard_masters: }), status: :ok
    end
  end
end
