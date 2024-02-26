class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :rememberable, :recoverable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  self.skip_session_storage = %i[http_auth params_auth]

  has_many :flashcard_masters
  has_many :favourites, dependent: :destroy
  has_one :user_def, dependent: :destroy
end
