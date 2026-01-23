require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }

  it { should belong_to(:author) }
  it { should belong_to(:best_answer).optional }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should respond_to(:mark_as_best) }

  it 'mark_as_best to the question' do
    question = create(:question)
    answer   = create(:answer, question: question)

    question.mark_as_best(answer)

    expect(question.best_answer).to eq(answer)
  end
end
