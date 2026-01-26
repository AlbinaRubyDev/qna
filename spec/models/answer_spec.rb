require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author) }

  it { should validate_presence_of :body }

  it { should respond_to(:this_best) }

  it 'this best answer boolean' do
    question = create(:question)
    answer1 = create(:answer, question: question)
    answer2 = create(:answer, question: question)

    question.mark_as_best(answer2)

    expect(answer1.this_best).to eq(false)
    expect(answer2.this_best).to eq(true)
  end
end
