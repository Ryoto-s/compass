class Api::V1::FavouritesController < FlashcardAttributesController
  def create
    flashcard_master = find_attributes_flashcard
    return unless flashcard_master

    found_favourite = flashcard_master.favourites
    if found_favourite.present?
      message = "Favourite already added. ID: #{params[:flashcard_id]}"
      render json: JSON.pretty_generate({ message:,
                                          favourite: found_favourite.as_json(only: %i[id flashcard_master_id
                                                                                      user_id]) }),
             status: :conflict
      return
    end

    ActiveRecord::Base.transaction do
      favourite =
        Favourite.create!({ user_id: current_user.id, flashcard_master_id: params[:flashcard_id] })
      message = "Favourite successfully added. ID: #{params[:flashcard_id]}"
      render json: JSON.pretty_generate(message:, favourite: favourite.as_json(
        only: %i[id flashcard_master_id user_id]
      )), status: :ok
    end
  end

  def destroy
    flashcard_master = find_attributes_flashcard
    return unless flashcard_master

    favourite = flashcard_master.favourites.first

    if favourite.nil?
      message = "Favourites not found. ID: #{params[:flashcard_id]}"
      render json: JSON.pretty_generate({ message:,
                                          favourite: }), status: :conflict
      return
    end
    ActiveRecord::Base.transaction do
      favourite.destroy!
      message = "Favourite successfully deleted. ID: #{flashcard_master.id}"
      render json: JSON.pretty_generate({ message:, favourite: {
                                          id: favourite.id,
                                          flashcard_master_id: flashcard_master.id,
                                          user_id: current_user.id
                                        } }), status: :ok
    end
  end
end
