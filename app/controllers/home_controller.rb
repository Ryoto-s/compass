class HomeController < ActionController::API
  before_action :authenticate_user!

  def index
    user_id =
      JWT.decode(request.headers['Authorization'].split(' ')[1], ENV['SECRET_KEY_BASE']).first['sub']
    home = FlashcardMaster.where(status: true, user_id:).limit(10)
    response_data = home.as_json(
      only: %i[id user_id use_image status],
      include: {
        flashcard_definitions: { only: %i[id word answer language] },
        tag_references: {
          include: {
            tag: { only: %i[id name status] }
          },
          only: %i[id flashcard_master_id tag_id]
        },
        favourites: { only: %i[id user_id flashcard_master_id] }
      }
    )
    render json: response_data
  end
end
