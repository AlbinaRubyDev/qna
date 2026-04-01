class CommentsController < ApplicationController
  before_action :find_commentable, only: [ :create ]

  after_action :publish_comment, only: [:create]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.turbo_stream
        format.html { redirect_to @commentable }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "#{@commentable.class.name.underscore}_#{@commentable.id}_new_comment",
            partial: "comments/form",
            locals: { commentable: @commentable, comment: @comment }
          ), status: :unprocessable_entity
        end

        format.html { redirect_to @commentable }
      end
    end
  end

  private

  def publish_comment
    return if @comment.errors.any?
  
    ActionCable.server.broadcast(
      "#{@commentable.class.name.underscore}_#{@commentable.id}_comments",
      {
        id: @comment.id,
        body: @comment.body
      }
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commentable
    @commentable = params[:commentable_type].constantize.find(params[:commentable_id])
  end
end
