require 'rails_helper'

RSpec.describe Answers::BestAnswerService do
  let!(:question_with_badge) { create(:question, :with_badge) }
  let!(:question_no_badge) { create(:question) }
  let!(:answer_with_badge) { create(:answer, question: question_with_badge) }
  let!(:answer_no_badge) { create(:answer, question: question_no_badge) }

  describe '#call' do
    context 'when question has badge' do
      it 'marks the answer as the best and rewards the author' do
        service = described_class.new(question_with_badge, answer_with_badge)

        expect { service.call }
          .to change { question_with_badge.reload.best_answer_id }
          .to(answer_with_badge.id)

        expect(answer_with_badge.author.badges).to include(question_with_badge.badge)
      end
    end

    context 'when question has no badge' do
      it 'marks the answer as the best without a reward' do
        service = described_class.new(question_no_badge, answer_no_badge)

        expect { service.call }
          .to change { question_no_badge.reload.best_answer_id }
          .to(answer_no_badge.id)

        expect(answer_no_badge.author.badges).to be_empty
      end
    end
  end
end
