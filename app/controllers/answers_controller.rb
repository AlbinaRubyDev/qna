class AnswersController < ApplicationController
  before_action :find_question, only: [ :create, :destroy, :best_answer ]
  before_action :find_answer, only: [ :destroy, :best_answer ]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user

    respond_to do |format|
      if @answer.save
        format.turbo_stream
        format.html { redirect_to @question }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            "new_answer",
            partial: "answers/form",
            locals: { answer: @answer, question: @question }),
            status: :unprocessable_entity
        end

        format.html do
          render "questions/show", status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    if @answer.author_id == current_user.id
      @answer.destroy

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove(@answer),
            turbo_stream.update(
              "flash",
              partial: "shared/turbo_flash",
              locals: { notice: "Your answer was succesfully deleted" }) ]
        end

        format.html { redirect_to @question }
      end
    else
      redirect_to question_path(@question)
    end
  end


  def best_answer
    if @question.author_id == current_user.id
      @question.mark_as_best(@answer)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(
              "flash",
              partial: "shared/turbo_flash",
              locals: { notice: "This answer was chosen as the best" }
            )
          ]
        end
        format.html { redirect_to @question }
      end
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
