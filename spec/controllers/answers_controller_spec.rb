require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create'  do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(question.answers, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
      end
    end

    describe 'PATCH #update' do
      let!(:answer) { create(:answer, question: question) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
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
          expect(response).to redirect_to question_path(question)
        end
      end

      context "the user deletes someone else's answer" do
        before { login(user) }

        it 'does NOT deletes the answer' do
          expect { delete :destroy, params: { question_id: question, id: answer } }.to_not change(Answer, :count)
        end

        it 'redirects to index' do
          delete :destroy, params: { question_id: question, id: answer }
          expect(response).to redirect_to question_path(question)
        end
      end
    end
  end
