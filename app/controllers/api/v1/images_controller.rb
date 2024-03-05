class Api::V1::ImagesController < FlashcardAttributesController
  # Access POST: /api/v1/images/:id/create to identify flashcard_master by ID
  def create
    ActiveRecord::Base.transaction do
      flashcard_master_for_create = find_attributes_flashcard
      return unless flashcard_master_for_create

      word = flashcard_master_for_create.flashcard_definition.word
      if flashcard_master_for_create.flashcard_image.present?
        return render_image_with_flashcard(flashcard_master_for_create,
                                           "Image already added. ID: #{flashcard_master_for_create.id}, word: #{word}", :unprocessable_entity)
      end

      flashcard_master_for_create.update(use_image: true)
      flashcard_master = upload_image(flashcard_master_for_create)
      render_image_with_flashcard(flashcard_master,
                                  "Image successfully added. ID: #{flashcard_master.id}, word: #{word}", :created)
    end
  end

  # Access PATCH: /api/v1/images/:id to identify flashcard_master by ID
  def update
    ActiveRecord::Base.transaction do
      flashcard_master = find_attributes_flashcard
      return unless flashcard_master

      word = flashcard_master.flashcard_definition.word
      if flashcard_master.use_image?
        remove_image_previously_added(flashcard_master)
        flashcard_master = upload_image(flashcard_master)
        render_image_with_flashcard(flashcard_master,
                                    "Image successfully updated. ID: #{flashcard_master.id}, word: #{word}", :ok)
      else
        render_image_with_flashcard([],
                                    "Image not updated. ID: #{flashcard_master.id}, word: #{word}", :ok)
      end
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      flashcard_master = find_attributes_flashcard
      return unless flashcard_master

      word = flashcard_master.flashcard_definition.word
      if flashcard_master.use_image?
        remove_image_previously_added(flashcard_master)
        flashcard_master.update(use_image: false)
        render_image_deleted(flashcard_master,
                             "Image successfully deleted. ID: #{flashcard_master.id}, word: #{word}", :ok)
      else
        render_image_with_flashcard([],
                                    "Image not deleted. ID: #{flashcard_master.id}, word: #{word}", :ok)
      end
    end
  end

  private

  def upload_image(flashcard_master)
    FlashcardImage.create!(image_params.merge(flashcard_master_id: flashcard_master.id))
    flashcard_master.reload
  end

  def image_params
    params.require(:flashcard_image).permit(:image)
  end

  def render_image_with_flashcard(flashcard_master, message, status)
    render json: JSON.pretty_generate({ message:, flashcard_master: flashcard_master.as_json(
      only: %i[id use_image status],
      include: { flashcard_definition: { only: %i[word] },
                 flashcard_image: { only: %i[id image] } }
    ) }), status:
  end

  def render_image_deleted(flashcard_master, message, status)
    render json: JSON.pretty_generate({ message:, flashcard_master: flashcard_master.as_json(
      only: %i[id use_image status],
      include: { flashcard_definition: { only: %i[word] } }
    ) }), status:
  end
end
