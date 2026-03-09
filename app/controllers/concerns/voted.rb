module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:cast_vote]
  end

  def cast_vote
    vote = @votable.votes.new(user: current_user, value: params[:value])

    if vote.save
      render json: { rating: @votable.votes.sum(:value) }
    else
      render json: { errors: vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
