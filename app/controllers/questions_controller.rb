class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, only: [ :show, :edit, :update, :destroy, :destroy_file ]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new(question: @question)
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_question",
            partial: "shared/redirect",
            locals: { url: question_path(@question) })
        end
        format.html { redirect_to @question }
      end
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            @question,
            partial: "questions/question",
            locals: { question: @question })
        end
        format.html { redirect_to @question }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user&.author_of?(@question)
      @question.remove_mark_best if @question.best_answer.present?

      @question.destroy
      redirect_to questions_path, notice: "Your question was succesfully deleted"
    else
      redirect_to questions_path
    end
  end

  def destroy_file
    return unless current_user&.author_of?(@question)

    @file = @question.files.find(params[:file_id])
    @file.purge

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @question }
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
