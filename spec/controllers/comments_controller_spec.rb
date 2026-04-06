require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new comment for question' do
        expect { post :create, params: { commentable_type: 'Question', commentable_id: question.id,
          comment: { body: 'Test comment for question' } }, format: :turbo_stream }.to change { question.comments.count }.by(1)
      end

        it 'saves a new comment for answer' do
        expect { post :create, params: { commentable_type: 'Answer', commentable_id: answer.id,
          comment: { body: 'Test comment for answer' } }, format: :turbo_stream }.to change { answer.comments.count }.by(1)
        end
      end

      context 'with invalid attributes' do
        it "does not save the comment' question" do
          expect { post :create, params: { commentable_type: 'Question', commentable_id: question.id,
            comment: { body: '' } }, format: :turbo_stream }.to_not change { question.comments.count }
        end
      end
  end
end
