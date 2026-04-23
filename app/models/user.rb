class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :omniauthable,
         omniauth_providers: [:github]

  has_many :answers, dependent: :destroy, foreign_key: :author_id
  has_many :authorizations, dependent: :destroy
  has_many :badges, dependent: :destroy
  has_many :questions, dependent: :destroy, foreign_key: :author_id

  AVATAR_SIZES = {
    micro: 16,
    thumb: 32,
    medium: 128,
    large: 512
  }

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def author_of?(object)
    id == object.author_id
  end

  def add_badge(badge)
    badges << badge
  end

  def gravatar_url(size)
    size = avatar_size(size)
  end

  def avatar_size(size)
    AVATAR_SIZES[size]
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
  end
end
