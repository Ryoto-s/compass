class Api::V1::HealthController < ApplicationController
  def index
    status = response.status
    status_str = status.to_s
    status_code = Rack::Utils::HTTP_STATUS_CODES[status]
    render json: { status: status_str, status_code: }
  end
end
