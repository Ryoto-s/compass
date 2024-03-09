class FlashcardAttributesController < BaseController
  # Common operations section
  def find_attributes_flashcard
    flashcard_master = FlashcardMaster.enabled
                                      .find_by(id: params[:flashcard_id],
                                               user_id: current_user.id)
    return unless render_inaccessible_entity(flashcard_master)

    flashcard_master
  end
end
