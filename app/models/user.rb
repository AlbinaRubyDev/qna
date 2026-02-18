class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :questions, dependent: :destroy, foreign_key: :author_id
  has_many :answers, dependent: :destroy, foreign_key: :author_id
  has_many :badges, dependent: :destroy

  def author_of?(object)
    id == object.author_id
  end

  def add_badge(badge)
    badges << badge
  end
end
