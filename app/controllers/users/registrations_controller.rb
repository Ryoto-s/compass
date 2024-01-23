# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      user_info = UserSerializer.new(resource).serializable_hash[:data][:attributes]
      render json: { status: { code: 200, message: 'Signed in successfully.' },
                     data: user_info, url: generate_registration_url(user_info[:id]) }
    else
      render json: {
        status: { message: 'Sign up failed' },
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }
    end
  end

  def generate_registration_url(user_id)
    token = SecureRandom.urlsafe_base64
    RegistrationToken.create(user_id:, token:)
    "#{ENV['BASE_URL']}/users/registration?token=#{token}"
  end
end
