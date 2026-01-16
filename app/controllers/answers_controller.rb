class AnswersController < ApplicationController
  before_action :find_question, only: [ :create, :destroy ]
  before_action :find_answer, only: [ :destroy ]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question
    else
      render "questions/show"
    end
  end

  def destroy
    if @answer.author_id == current_user.id
      @answer.destroy
      redirect_to question_path(@question), notice: "Your answer was succesfully deleted"
    else
      redirect_to question_path(@question)
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
