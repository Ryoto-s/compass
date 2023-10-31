class Api::V1::WordBooksController < ApplicationController
  before_action :authenticate_user!

  def show
    @word_book_master = WordBookMaster.where('status = true AND id = ? AND user_id = ?', params[:id], user_id)
    render json: @word_book_master.as_json(
      only: %i[id user_id use_image],
      include: { word_definitions: { only: %i[word answer language] } }
    )
  end

  def search
    # Search for words by access /api/v1/word_books/search?q=foo+bar+anyString
    @word_book_master = keywords.map do |keyword|
      sql_keyword = sql_keyword(keyword)
      WordBookMaster.joins(:word_definitions).where(
        'status = true AND user_id = ? AND ( word LIKE ? OR answer LIKE ? OR language LIKE ? )',
        user_id, "%#{sql_keyword}%", "%#{sql_keyword}%", "%#{sql_keyword}%"
      )
    end.flatten.uniq
    render json: { result: @word_book_master.as_json(
      only: %i[id user_id use_image status],
      include: { word_definitions: { only: %i[word answer language] } }
    ) }
  end

  def global_search
    # Search for words by access /api/v1/word_booksglobal_search?q=foo+bar+anyString
    @word_book_master = keywords.map do |keyword|
      sql_keyword = sql_keyword(keyword)
      WordBookMaster.joins(:word_definitions).where('status = true AND word LIKE ? OR answer LIKE ? OR language LIKE ?',
                                                    "%#{sql_keyword}%", "%#{sql_keyword}%", "%#{sql_keyword}%")
    end.flatten.uniq
    render json: { result: @word_book_master.as_json(
      only: %i[id user_id use_image status],
      include: { word_definitions: { only: %i[word answer language] } }
    ) }
  end

  def create
    word_book_master = WordBookMaster.create!(master_params.merge(:user_id))
    WordDefinition.create!(definition_params.merge(word_book_master_id: word_book_master.id))

    render json: { created_word: word_book_master.as_json(
      only: %i[id user_id use_image status],
      include: { word_definitions: { only: %i[word answer language] } }
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
    params.require(:word_book_master).permit(:user_id, :use_image, :status)
  end

  def definition_params
    params.require(:word_definitions).permit(:word, :answer, :language)
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
