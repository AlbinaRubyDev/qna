require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create'  do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(question.answers, :count)
      end

      it 're-renders question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template('questions/show')
      end
      end
    end

    describe 'DELETE #destroy' do
      let!(:author) { create(:user) }
      let!(:answer) { create(:answer, question: question, author: author) }

      context 'the author deletes his answer' do
        before { login(author) }

        it 'deletes the answer' do
          expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
        end

        it 'redirects to index' do
          delete :destroy, params: { question_id: question, id: answer }
          expect(response).to redirect_to questions_path
        end
      end

      context "the user deletes someone else's answer" do
        before { login(user) }

        it 'does NOT deletes the answer' do
          expect { delete :destroy, params: { question_id: question, id: answer } }.to_not change(Answer, :count)
        end

        it 'redirects to index' do
          delete :destroy, params: { question_id: question, id: answer }
          expect(response).to redirect_to questions_path
        end
      end
    end
  end
