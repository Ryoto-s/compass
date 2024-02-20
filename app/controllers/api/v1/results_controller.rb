class Api::V1::ResultsController < BaseController
  def show
    flashcard_master = find_flashcard_master
    return unless flashcard_master

    render json: JSON.pretty_generate({ flashcard_master: flashcard_master.as_json(
      only: %i[id use_image],
      include: { flashcard_definition: { only: %i[id word language] },
                 results: { only: %i[id result updated_at] } }
    ) }), status: :ok
  end

  def answer
    ActiveRecord::Base.transaction do
      flashcard_master = find_flashcard_master
      return unless flashcard_master

      flashcard_definition = flashcard_master.flashcard_definition
      word = flashcard_definition.word
      if flashcard_master.input_enabled?
        process_input_enabled_flashcard(flashcard_master, word)
      else
        process_input_disabled_flashcard(flashcard_master, word)
      end
    end
  end

  # Update marked status 0f result
  def update
    ActiveRecord::Base.transaction do
      flashcard_master = find_flashcard_master
      return unless flashcard_master

      result = Result.find_by(id: params[:result_id], flashcard_master_id: params[:id])
      result.update!(result_params)
      flashcard_master.reload
      word = flashcard_master.flashcard_definition.word
      message = "Answer successfully modified, mark as: '#{params[:results][:result]}'! word: #{word}"
      render_result(flashcard_master, result, message, :ok)
    end
  end

  def latest_result
    found_flashcard_master = find_flashcard_master
    return unless found_flashcard_master

    latest_result = found_flashcard_master.latest_result
    if latest_result.blank?
      message = "Result not found. ID: #{found_flashcard_master.id}"
      render_result(found_flashcard_master, [], message, :not_found)
    else
      flashcard_master =
        {
          id: found_flashcard_master.id,
          input_enabled: found_flashcard_master.input_enabled,
          flashcard_definition: {
            id: found_flashcard_master.flashcard_definition.id,
            word: found_flashcard_master.flashcard_definition.word,
            answer: found_flashcard_master.flashcard_definition.answer,
            language: found_flashcard_master.flashcard_definition.language
          },
          latest_result: latest_result.as_json(only: %i[id result updated_at])
        }
      message = "Last result marked as: #{latest_result.result.upcase}. ID: #{found_flashcard_master.id}"
      render json: JSON.pretty_generate({ message:, flashcard_master: }), status: :ok
    end
  end

  private

  def process_input_enabled_flashcard(flashcard_master, word)
    # User inserted answer text
    processed_answer_input = lower_and_substring_space(params[:answer])
    # Registered answer text
    answer = flashcard_master.flashcard_definition.answer
    processed_answer = lower_and_substring_space(answer)
    if processed_answer_input == processed_answer
      answer_result = :correct
      message = "Correct answer! word: #{word}"
    else
      answer_result = :incorrect
      message = "Incorrect answer! word: #{word}"
    end
    result = Result.create!(result: answer_result, flashcard_master_id: params[:id],
                            user_id: current_user.id)
    render_result(flashcard_master, result, message, :created)
  end

  def process_input_disabled_flashcard(flashcard_master, word)
    # To put param such as correct, incorrect, intermediate, and not_sure by answerer's self
    result = Result.create!(result_params.merge(flashcard_master_id: params[:id], user_id: current_user.id))
    message = "Answer successfully registered, mark as: '#{params[:results][:result]}'! word: #{word}"
    render_result(flashcard_master, result, message, :created)
  end

  def lower_and_substring_space(text)
    return '' if text.blank?

    text.downcase.gsub(/\s+/, '')
  end

  def result_params
    params.require(:results).permit(:result)
  end

  def render_result(flashcard_master, result, message, status)
    render json: JSON.pretty_generate({ message:,
                                        result: result.as_json(only: %i[result updated_at]),
                                        flashcard_master: flashcard_master.as_json(
                                          only: %i[id input_enabled],
                                          include: { flashcard_definition: { only: %i[id word answer language] },
                                                     flashcard_image: { only: %i[image] },
                                                     results: { only: %i[result updated_at] } }
                                        ) }), status:
  end
end
