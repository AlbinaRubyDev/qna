require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_one(:badge).dependent(:destroy) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }

  it { should belong_to(:author) }
  it { should belong_to(:best_answer).optional }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :badge }
  it { should accept_nested_attributes_for :links }

  it { should respond_to(:mark_as_best) }

  it 'mark_as_best to the question' do
    question = create(:question)
    answer   = create(:answer, question: question)

    question.mark_as_best(answer)

    expect(question.best_answer).to eq(answer)
  end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
