class HealthController < ApplicationController
  def index
    status = response.status
    status_str = status.to_s
    status_code = Rack::Utils::HTTP_STATUS_CODES[status]
    render json: JSON.pretty_generate({ status: status_code, time: Time.now }), status: status_str
  end
end
