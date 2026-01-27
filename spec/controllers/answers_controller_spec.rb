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

describe 'PATCH #update' do
  let!(:author) { create(:user) }
  let!(:answer) { create(:answer, question: question, author: author) }

  context 'author updates answer' do
    before { login(author) }

    it 'assigns the requested answer' do
      patch :update, params: { id: answer.id, answer: attributes_for(:answer), question_id: question.id }
      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      patch :update, params: { id: answer.id, answer: { body: 'new answer body' }, question_id: question.id }
      answer.reload

      expect(answer.body).to eq 'new answer body'
    end

    it 'redirects to question' do
      patch :update, params: { id: answer.id, answer: { body: 'new answer body' }, question_id: question.id },
      format: :html
      expect(response).to redirect_to question
    end
  end

  context 'another user is trying to edit the answer' do
    before { login(user) }

    it 'changes answer attributes' do
      patch :update, params: { id: answer.id, answer: { body: 'new answer body' }, question_id: question.id }
      answer.reload

      expect(answer.body).to eq answer.body
      expect(answer.body).to_not eq 'new answer body'
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

    it 'redirects to question' do
      delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context "the user deletes someone else's answer" do
      before { login(user) }

      it 'does NOT deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'DELETE #destroy_file' do
    let!(:author) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, :with_files, question: question, author: author) }
    let(:file) { answer.files.first }

    context 'author deletes file' do
      before { login(author) }

      it 'the file has been deleted' do
        expect { delete :destroy_file, params: { id: answer, question_id: question.id, file_id: file.id },
                format: :turbo_stream }.to change { answer.files.count }.by(-1)
      end
    end

    context 'another user cannot delete the file' do
      before { login(user) }

      it 'the file was not deleted' do
        expect { delete :destroy_file, params: { id: answer, question_id: question.id, file_id: file.id   },
                 format: :turbo_stream }.to_not change { answer.files.count }
      end
    end
  end

    describe 'PATCH #best_answer' do
      let!(:author) { create(:user) }
      let!(:user) { create(:user) }
      let!(:question) { create(:question, author: author) }
      let!(:answer1) { create(:answer, question: question) }
      let!(:answer2) { create(:answer, question: question) }

      context 'author' do
        before { login(author) }

        it 'appoints the best answer' do
          question.mark_as_best(answer1)
          patch :best_answer, params: { id: answer2.id, question_id: question.id }

          question.reload
          expect(question.best_answer).to eq(answer2)
        end
      end

      context "other user" do
        before { login(user) }

        it 'does not change the best answer' do
          question.mark_as_best(answer1)
          patch :best_answer, params: { id: answer2.id, question_id: question.id }

          question.reload
          expect(question.best_answer).to eq(answer1)
        end
      end
    end
  end
