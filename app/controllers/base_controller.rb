class BaseController < ApplicationController
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  rescue_from StandardError, with: :handle_standard_error

  private

  def handle_record_invalid(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def handle_record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def handle_standard_error(exception)
    render json: { error: exception.message }, status: :internal_server_error
  end

  def find_flashcard_master
    flashcard_master = FlashcardMaster.enabled.find_by(id: params[:id], user_id: current_user.id)
    return unless render_inaccessible_entity(flashcard_master)

    flashcard_master
  end

  def render_inaccessible_entity(flashcard_master)
    if flashcard_master.nil?
      render json: JSON.pretty_generate({ flashcard: 'Not found' }), status: :not_found
      return false
    elsif flashcard_master.user_id != current_user.id
      render json: JSON.pretty_generate(flashcard: 'Edit unauthorized'), status: :unauthorized
      return false
    elsif flashcard_master.status == 'disabled'
      render json: JSON.pretty_generate(flashcard: 'Flashcard disabled'),
             status: :unprocessable_entity
      return false
    end
    true
  end
end
