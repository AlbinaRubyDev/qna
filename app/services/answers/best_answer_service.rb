module Answers
  class BestAnswerService
    def initialize(question, answer)
      @question = question
      @answer = answer
    end

    def call
      ActiveRecord::Base.transaction do
        @question.mark_as_best(@answer)

        if @question.badge.present?
          @answer.author.add_badge(@question.badge)
        end
      end

      @best_answer = @question.best_answer
      @other_answers = @question.answers.where.not(id: @question.best_answer_id)

      { best_answer: @best_answer, other_answers: @other_answers }
    end
  end
end
