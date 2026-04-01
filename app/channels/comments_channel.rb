class CommentsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def follow(data)
    stream_from "#{data['commentable_type'].underscore}_#{data['commentable_id']}_comments"
  end
end
