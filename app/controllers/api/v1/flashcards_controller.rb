class Api::V1::FlashcardsController < BaseController
  def show
    flashcard_master = find_flashcard_master
    return unless flashcard_master

    word = flashcard_master.flashcard_definition.word
    render_flashcard_common(flashcard_master, :ok, "Flashcard found. ID: #{params[:id]}, word: #{word}")
  end

  # Search for cards by access /api/v1/flashcards/search?q=foo+bar+anyString
  def search
    keywords = search_keywords
    # Reject if keyword is not specified
    return render_flashcard_common([], :ok, 'No keywords provided') if keywords.blank?

    flashcard_masters = keywords.map do |keyword|
      FlashcardMaster.enabled.joins(:flashcard_definition).where(user_id: current_user.id)
                     .where(
                       'word LIKE ? OR answer LIKE ? OR language LIKE ?',
                       "%#{keyword}%", "%#{keyword}%", "%#{keyword}%"
                     )
    end.flatten.uniq
    render_flashcard_common(flashcard_masters, :ok, "Found #{flashcard_masters.count} flashcards")
  end

  # Search for cards by access /api/v1/flashcards/global_search?q=foo+bar+anyString
  def global_search
    keywords = search_keywords
    # Reject if keyword is not specified
    return render_flashcard_common([], :ok, 'No keywords provided') if keywords.blank?

    # Apply keywords for each parameters
    condition_strings = keywords.each_with_index.map do |_keyword, index|
      "(word LIKE :keyword#{index} OR answer LIKE :keyword#{index} OR language LIKE :keyword#{index})"
    end.join(' OR ')
    parameters = keywords.each_with_index.reduce({ user_id: current_user.id }) do |params, (keyword, index)|
      params.merge!("keyword#{index}".to_sym => "%#{keyword}%")
    end

    flashcard_masters = FlashcardMaster.enabled.joins(:flashcard_definition)
                                       .where(condition_strings, parameters)
                                       .where('shared_flag = ? OR user_id = ?',
                                              FlashcardMaster.shared_flags[:public_card], current_user.id)
                                       .distinct

    render_flashcard_common(flashcard_masters, :ok, "Found #{flashcard_masters.count} flashcards")
  end

  def create
    ActiveRecord::Base.transaction do
      flashcard_master = FlashcardMaster.create!(master_params.merge(user_id: current_user.id, status: true))
      render json: JSON.pretty_generate({ flashcard_master: flashcard_master.as_json(
        only: %i[id user_id use_image input_enabled shared_flag status],
        include: { flashcard_definition: { only: %i[id word answer language] } }
      ) }), status: :created
    end
  end

  def update
    flashcard_master = find_flashcard_master
    return unless flashcard_master

    ActiveRecord::Base.transaction do
      flashcard_master.update!(master_params)
      updated_word = flashcard_master.flashcard_definition.word
      updated_message = "Flashcard successfully updated. ID: #{flashcard_master.id}, word: #{updated_word}"
      render_flashcard_common(flashcard_master, :ok, updated_message)
    end
  end

  def destroy
    flashcard_master = find_flashcard_master
    return unless flashcard_master

    # Disabled flashcard would rejected above, but code this for security
    unless flashcard_master.status == 'enabled'
      return render_error_response(
        "Flashcard already deleted. id: #{flashcard_master.id}, word: #{flashcard_master.flashcard_definition.word}", :ok
      )
    end

    ActiveRecord::Base.transaction do
      remove_image_previously_added(flashcard_master) if flashcard_master.flashcard_image.present?

      flashcard_master.update(status: false)
      render_deleted_flashcard(flashcard_master, :ok,
                               "successfully deleted flashcard. ID: #{flashcard_master.id}, word: #{flashcard_master.flashcard_definition.word}")
    end
  end

  private

  def search_keywords
    params = request.query_parameters
    return [] if params.blank?

    keywords = params['q'].to_s.split(/\s+/).reject(&:empty?)
    keywords.map do |keyword|
      ActiveRecord::Base.sanitize_sql_like(keyword)
    end.flatten.uniq # remove duplicate of keywords
  end

  def render_flashcard_common(flashcard_master, status, message)
    render json: JSON.pretty_generate({ message:,
                                        flashcard_master: flashcard_master.as_json(
                                          only: %i[id user_id use_image input_enabled shared_flag status],
                                          include: { flashcard_definition: { only: %i[id word answer language] },
                                                     flashcard_image: { only: %i[image] } }
                                        ) }), status:
  end

  def render_deleted_flashcard(flashcard_master, status, message)
    render json: JSON.pretty_generate({
                                        message:,
                                        flashcard_master: flashcard_master.as_json(
                                          only: %i[id user_id use_image],
                                          include: { flashcard_definition: { only: %i[word] } }
                                        )
                                      }), status:
  end

  def master_params
    params.require(:flashcard_master)
          .permit(:use_image, :input_enabled, :shared_flag, :status,
                  flashcard_definition_attributes: %i[id word answer language _destroy])
  end
end
