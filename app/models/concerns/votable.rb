module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def user_voted?(user)
    votes.exists?(user: user)
  end
end
