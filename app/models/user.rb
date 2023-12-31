class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :rememberable, :recoverable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  self.skip_session_storage = %i[http_auth params_auth]

  has_many :word_book_masters
  has_many :favourites
  has_one :user_def
end
