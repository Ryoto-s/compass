class Api::V1::ResultsController < BaseController
  def show
    flashcard_master = find_flashcard_master
    render json: JSON.pretty_generate({ flashcard_master: flashcard_master.as_json(
      only: %i[id use_image],
      include: { flashcard_definition: { only: %i[id word language] },
                 results: { only: %i[id result learned_at] },
                 flashcard_image: { only: %i[image] } }
    ) }), status: :ok
  end

  def update
    ActiveRecord::Base.transaction do
      flashcard_master = find_flashcard_master
      learned_at = Time.now
      if flashcard_master.input_enabled?
        flashcard_definition = flashcard_master.flashcard_definition
        word = flashcard_definition.word
        answered = params[:answered]
        answered_ignore = lower_and_substring_space(answered)
        answer = flashcard_definition.answer
        answer_ignore = lower_and_substring_space(answer)
        if answered_ignore == answer_ignore
          answer_result = 0
          message = "Correct answer! word: #{word}"
        else
          answer_result = 2
          message = "Incorrect answer! word: #{word}"
        end
        result = Result.create!(result: answer_result, learned_at:, flashcard_master_id: params[:id],
                                user_id: current_user.id)
        return render_result(flashcard_master, message, result, :ok)
      end
      # To put param such as correct, incorrect, intermediate, and not_sure by answerer's self
      answer_result = params[:answered]
      result = Result.create!(result: answer_result, learned_at:, flashcard_master_id: params[:id],
                              user_id: current_user.id)
      render json: JSON.pretty_generate({ message:,
                                          result:,
                                          flashcard_master: flashcard_master.as_json(
                                            only: %i[id input_enabled],
                                            include: { flashcard_definition: { only: %i[id word answer language] },
                                                       flashcard_image: { only: %i[image] },
                                                       results: { only: %i[result learned_at] } }
                                          ) }), status: :ok
    end
  end

  def last_result
    render json: {}, status: :ok
  end

  private

  def lower_and_substring_space(text)
    render(json: { message: '' }, status:) if text.blank?
    text.downcase.gsub(/\s+/, '')
  end

  def render_result(flashcard_master, message, result, status)
    render json: JSON.pretty_generate({ message:,
                                                   result:,
                                                   flashcard_master: flashcard_master.as_json(
                                                     only: %i[id input_enabled],
                                                     include: { flashcard_definition: { only: %i[id word answer language] },
                                                                flashcard_image: { only: %i[image] },
                                                                results: { only: %i[result learned_at] } }
                                                   ) }), status: status
  end
end
