class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User"

  validates :body, presence: true

  def this_best
    if question.best_answer_id == self.id
      true
    else
      false
    end
  end
end
