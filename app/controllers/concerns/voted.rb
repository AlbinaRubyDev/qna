module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:cast_vote, :cancel_vote]
  end

  def cast_vote
    return if current_user&.author_of?(@votable)

    vote = @votable.votes.new(user: current_user, value: params[:value])

    if vote.save
      render json: { rating: @votable.votes.sum(:value),
        voted: @votable.user_voted?(current_user) }
    else
      render json: { rating: @votable.votes.sum(:value), voted: @votable.user_voted?(current_user),
        errors: vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def cancel_vote
    vote = @votable.votes.find_by(user: current_user)
    vote&.destroy
  
    render json: { rating: @votable.votes.sum(:value) }
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
