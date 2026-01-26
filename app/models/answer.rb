class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User"

  has_one_attached :file

  validates :body, presence: true

  def this_best
    question.best_answer_id == self.id
  end
end
