class Api::V1::ResultsController < BaseController
  def show
    flashcard_master = find_flashcard_master
    return unless flashcard_master

    render json: JSON.pretty_generate({ flashcard_master: flashcard_master.as_json(
      only: %i[id use_image],
      include: { flashcard_definition: { only: %i[id word language] },
                 results: { only: %i[id result learned_at] },
                 flashcard_image: { only: %i[image] } }
    ) }), status: :ok
  end

  def create
    ActiveRecord::Base.transaction do
      flashcard_master = find_flashcard_master
      return unless flashcard_master

      learned_at = Time.now
      flashcard_definition = flashcard_master.flashcard_definition
      word = flashcard_definition.word
      if flashcard_master.input_enabled?
        process_input_enabled_flashcard(flashcard_master, word, learned_at)
      else
        process_input_disabled_flashcard(flashcard_master, word, learned_at)
      end
    end
  end

  def last_result
    render json: {}, status: :ok
  end

  private

  def process_input_enabled_flashcard(flashcard_master, word, learned_at)
    # Answer text from user input
    processed_answer_input = lower_and_substring_space(params[:answer])
    # Answer text from registered
    answer = flashcard_master.flashcard_definition.answer
    processed_answer = lower_and_substring_space(answer)
    if processed_answer_input == processed_answer
      answer_result = :correct
      message = "Correct answer! word: #{word}"
    else
      answer_result = :incorrect
      message = "Incorrect answer! word: #{word}"
    end
    result = Result.create!(result: answer_result, learned_at:, flashcard_master_id: params[:id],
                            user_id: current_user.id)
    render_result(flashcard_master, message, result, :ok)
  end

  def process_input_disabled_flashcard(flashcard_master, word, learned_at)
    # To put param such as correct, incorrect, intermediate, and not_sure by answerer's self
    result = Result.create!(result_params.merge(learned_at:,
                                                flashcard_master_id: params[:id], user_id: current_user.id))
    message = "Answer successfully registered, mark as: '#{params[:results][:result]}'! word: #{word}"
    render json: JSON.pretty_generate({ message:,
                                        result:,
                                        flashcard_master: flashcard_master.as_json(
                                          only: %i[id input_enabled],
                                          include: { flashcard_definition: { only: %i[id word answer language] },
                                                     flashcard_image: { only: %i[image] },
                                                     results: { only: %i[result learned_at] } }
                                        ) }), status: :ok
  end

  def lower_and_substring_space(text)
    return '' if text.blank?

    text.downcase.gsub(/\s+/, '')
  end

  def result_params
    params.require(:results).permit(:result)
  end

  def render_result(flashcard_master, message, result, status)
    render json: JSON.pretty_generate({ message:,
                                        result:,
                                        flashcard_master: flashcard_master.as_json(
                                          only: %i[id input_enabled],
                                          include: { flashcard_definition: { only: %i[id word answer language] },
                                                     flashcard_image: { only: %i[image] },
                                                     results: { only: %i[result learned_at] } }
                                        ) }), status:
  end
end
