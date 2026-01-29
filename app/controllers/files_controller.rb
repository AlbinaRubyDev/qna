class FilesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @association = ActiveStorage::Attachment.find(params[:id])
    object = @association.record

    return unless current_user&.author_of?(object)

    question_path = object.is_a?(Answer) ? object.question : object
    @association.purge

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to question_path }
    end
  end
end
