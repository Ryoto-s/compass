class Api::V1::FlashcardsController < ApplicationController
  before_action :authenticate_user!

  def show
    flashcard_master = FlashcardMaster.where('status = true AND id = ? AND user_id = ?', params[:id], user_id)
    render json: flashcard_master.as_json(
      only: %i[id user_id use_image],
      include: { flashcard_definitions: { only: %i[word answer language] } }
    )
  end

  def search
    # Search for cards by access /api/v1/flashcards/search?q=foo+bar+anyString
    flashcard_master = keywords.map do |keyword|
      sql_keyword = sql_keyword(keyword)
      FlashcardMaster.joins(:flashcard_definitions).where(
        'status = true AND user_id = ? AND ( word LIKE ? OR answer LIKE ? OR language LIKE ? )',
        user_id, "%#{sql_keyword}%", "%#{sql_keyword}%", "%#{sql_keyword}%"
      )
    end.flatten.uniq
    render json: { result: flashcard_master.as_json(
      only: %i[id user_id use_image status],
      include: { flashcard_definitions: { only: %i[word answer language] } }
    ) }
  end

  def global_search
    # Search for cards by access /api/v1/flashcards/global_search?q=foo+bar+anyString
    flashcard_master = keywords.map do |keyword|
      sql_keyword = sql_keyword(keyword)
      FlashcardMaster.joins(:flashcard_definitions).where('status = true AND word LIKE ? OR answer LIKE ? OR language LIKE ?',
                                                    "%#{sql_keyword}%", "%#{sql_keyword}%", "%#{sql_keyword}%")
    end.flatten.uniq
    render json: { result: flashcard_master.as_json(
      only: %i[id user_id use_image status],
      include: { flashcard_definitions: { only: %i[word answer language] } }
    ) }
  end

  def create
    flashcard_master = FlashcardMaster.create!(master_params.merge(user_id:))
    FlashcardDefinition.create!(definition_params.merge(flashcard_master_id: flashcard_master.id))

    render json: { created_card: flashcard_master.as_json(
      only: %i[id user_id use_image status],
      include: { flashcard_definitions: { only: %i[word answer language] } }
    ) }
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def edit; end

  def update; end

  def destroy; end

  def answer; end

  private

  def master_params
    params.require(:flashcard_master).permit(:user_id, :use_image, :status)
  end

  def definition_params
    params.require(:flashcard_definition).permit(:word, :answer, :language)
  end

  def user_id
    JWT.decode(request.headers['Authorization'].split(' ')[1], ENV['SECRET_KEY_BASE']).first['sub']
  end

  def keywords
    params = request.query_parameters
    params['q'].split(/\s+/).reject(&:empty?)
  end

  def sql_keyword(keyword)
    ActiveRecord::Base.sanitize_sql_like(keyword)
  end
end
