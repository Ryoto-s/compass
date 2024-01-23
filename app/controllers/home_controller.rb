class HomeController < ActionController::API
  before_action :authenticate_user!

  # All data included
  def index
    home = FlashcardMaster.enabled.where(status: true, user_id: current_user.id)
    if home.empty?
      render json: { message: 'Data not set' }, status: :unprocessable_entity
    else
      # In this resource, the tag_reference will be shown even if tag is deleted.
      # Try fix this in the future.
      # response_data = FlashcardMasterResource.new(home).serialize
      render json: { response_data: :home, status: :ok }
      response_data = FlashcardMasterResource.new(home).serialize
      render json: { response_data:, status: :ok }
    end
  end
end
