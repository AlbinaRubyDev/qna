class LinksController < ApplicationController
  before_action :find_link, only: [ :destroy ]

  def destroy
    return unless current_user&.author_of?(@link.linkable)

    @link.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to question_path }
    end
  end

  private

  def find_link
    @link = Link.find(params[:id])
  end
end
