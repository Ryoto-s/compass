class NotFoundController < ApplicationController
  def handle_routing_error
    path = request.fullpath
    error = "Requested URL #{path} was not found"
    render json: JSON.pretty_generate({ error: }), status: :not_found
  end
end
