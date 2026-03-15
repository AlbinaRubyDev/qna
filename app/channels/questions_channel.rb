class QuestionsChannel < ApplicationCable::Channel
  def subscribed
  end

  def unsubscribed
  end

  def follow
    stream_from "questions"
  end
end
