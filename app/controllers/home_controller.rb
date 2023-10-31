class HomeController < ActionController::API
  before_action :authenticate_user!

  def index
    user_id =
      JWT.decode(request.headers['Authorization'].split(' ')[1], ENV['SECRET_KEY_BASE']).first['sub']
    @home = WordBookMaster.where(status: true, user_id:).limit(10)
    response_data = @home.as_json(
      only: %i[id user_id use_image status],
      include: {
        word_definition: { only: %i[id word answer language] },
        tag_reference: {
          include: {
            tag: { only: %i[id name status] }
          },
          only: %i[id word_book_master_id tag_id]
        },
        favourite: { only: %i[id user_id word_book_master_id] }
      }
    )
    render json: response_data
  end

end
