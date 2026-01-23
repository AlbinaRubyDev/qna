class Question < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :best_answer, class_name: "Answer", optional: true

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def mark_as_best(answer)
    update(best_answer_id: answer.id)
  end

  def remove_mark_best(answer)
    update(best_answer_id: nil)
  end
end
