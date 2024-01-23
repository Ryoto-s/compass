class Api::V1::FlashcardsController < ApplicationController
  before_action :authenticate_user!

  def show
    flashcard_master = FlashcardMaster.where(status: true, id: params[:id], user_id: current_user.id)
    render json: flashcard_master.as_json(
      only: %i[id user_id use_image],
      include: { flashcard_definition: { only: %i[word answer language] } }
    )
  end

  def search
    # Search for cards by access /api/v1/flashcards/search?q=foo+bar+anyString
    flashcard_master = search_keywords.map do |keyword|
      FlashcardMaster.joins(:flashcard_definition).where(
        'status = true AND user_id = ? AND ( word LIKE ? OR answer LIKE ? OR language LIKE ? )',
        current_user.id, "%#{keyword}%", "%#{keyword}%", "%#{keyword}%"
      )
    end.flatten.uniq
    render json: { result: flashcard_master.as_json(
      only: %i[id user_id use_image status],
      include: { flashcard_definition: { only: %i[word answer language] } }
    ) }
  end

  def global_search
    # Search for cards by access /api/v1/flashcards/global_search?q=foo+bar+anyString
    flashcard_master = search_keywords.map do |keyword|
      FlashcardMaster.joins(:flashcard_definition).where('status = true AND word LIKE ? OR answer LIKE ? OR language LIKE ?',
                                                         "%#{keyword}%", "%#{keyword}%", "%#{keyword}%")
    end.flatten.uniq
    render json: { result: flashcard_master.as_json(
      only: %i[id user_id use_image status],
      include: { flashcard_definition: { only: %i[word answer language] } }
    ) }
  end

  def create
    flashcard_master = FlashcardMaster.create!(master_params.merge(user_id: current_user.id))
    FlashcardDefinition.create!(definition_params.merge(flashcard_master_id: flashcard_master.id))

    render json: JSON.pretty_generate({ created_card: flashcard_master.as_json(
      only: %i[id user_id use_image status],
      include: { flashcard_definition: { only: %i[word answer language] } }
    ) }, status: :created)
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def edit
    flashcard_definition = FlashcardDefinition.find(params[:id])
    flashcard_master = FlashcardMaster.find(flashcard_definition.flashcard_master_id)
    if flashcard_master.user_id != current_user.id
      render json: JSON.pretty_generate(flashcard: 'Edit unauthorized', status: :unauthorized)
    end
    if flashcard_master.status == false
      render json: JSON.pretty_generate(flashcard: 'Flashcard disabled', status: :unprocessable_entity)
    else
      render json: JSON.pretty_generate({ flashcard_definition: flashcard_definition.as_json(
        only: %i[id flashcard_master_id word answer language]
      ) }, status: :ok)
    end
  end

  def update
    flashcard_definition = FlashcardDefinition.find(params[:id])
    flashcard_master = FlashcardMaster.find(flashcard_definition.flashcard_master_id)
    if flashcard_master.user_id != current_user.id
      render json: JSON.pretty_generate(flashcard: 'Edit unauthorized', status: :unauthorized)
    end
    if flashcard_definition.update(definition_params)
      flashcard_master = FlashcardMaster.find(flashcard_definition.flashcard_master_id)
      render json: JSON.pretty_generate({ updated_content: flashcard_master.as_json(
        only: %i[id status use_image],
        include: { flashcard_definition: { only: %i[word answer language] } }
      ) }, status: :ok)
    else
      render json: JSON.pretty_generate({ flashcard_definition: flashcard_definition.errors }, status: 500)
    end
  end

  def destroy
    flashcard_master = FlashcardMaster.find(params[:id])
    if flashcard_master.user_id != current_user.id
      render json: JSON.pretty_generate(flashcard: 'Delete unauthorized', status: :unauthorized)
    end
    if flashcard_master.update(status: false)
      render json: JSON.pretty_generate(message: "successfully deleted flashcard_master_id: #{flashcard_master.id}",
                                        status: :ok)
    else
      render json: JSON.pretty_generate(message: "deletion faild at flashcard_master_id #{flashcard_master.id}",
                                        status: 500)
    end
  end

  private

  def master_params
    params.require(:flashcard_master).permit(:user_id, :use_image, :input_enabled, :status)
  end

  def definition_params
    params.require(:flashcard_definition).permit(:word, :answer, :language)
  end

  def search_keywords
    params = request.query_parameters
    keywords = params['q'].split(/\s+/).reject(&:empty?)
    keywords.map do |keyword|
      ActiveRecord::Base.sanitize_sql_like(keyword)
    end.flatten.uniq # remove duplicate of keywords
  end
end
