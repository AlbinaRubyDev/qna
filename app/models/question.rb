class Question < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :best_answer, class_name: "Answer", optional: true

  has_many :answers, dependent: :destroy
  has_one :badge, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :badge, reject_if: :all_blank

  validates :title, :body, presence: true

  def mark_as_best(answer)
    update(best_answer_id: answer.id)
  end

  def remove_mark_best
    update(best_answer_id: nil)
  end
end
