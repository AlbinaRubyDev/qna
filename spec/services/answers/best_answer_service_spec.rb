require 'rails_helper'

RSpec.describe Answers::BestAnswerService do
  let!(:question_with_badge) { create(:question, :with_badge) }
  let!(:question_no_badge) { create(:question) }
  let!(:answer_with_badge) { create(:answer, question: question_with_badge) }
  let!(:answer_no_badge) { create(:answer, question: question_no_badge) }

  describe '#call' do
    context 'the answer marked the best for the question' do
      it 'sets the best_answer_id for the question' do
        service = described_class.new(question_with_badge, answer_with_badge)

        expect { service.call }
          .to change { question_with_badge.reload.best_answer_id }
          .to(answer_with_badge.id)
      end
    end

    context 'when question has badge' do
      it 'rewards the author' do
        service = described_class.new(question_with_badge, answer_with_badge)

        expect { service.call }
          .to change { answer_with_badge.author.badges.count }
          .by(1)

        expect(answer_with_badge.author.badges).to include(question_with_badge.badge)
      end
    end

    context 'when question has no badge' do
      it 'does not reward the author' do
        service = described_class.new(question_no_badge, answer_no_badge)

        expect { service.call }
          .to_not change { answer_no_badge.author.badges.count }
      end
    end
  end
end
