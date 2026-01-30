require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    let!(:author_question) { create(:user) }
    let!(:question) { create(:question, :with_files, author: author_question) }
    let(:file_question) { question.files.first }

    let!(:author_answer) { create(:user) }
    let!(:answer) { create(:answer, :with_files, question: question, author: author_answer) }
    let(:file_answer) { answer.files.first }

    context "author deletes file" do
      it "The question's attached files are being deleted" do
        login(author_question)

        expect { delete :destroy, params: { id: file_question.id },
                format: :turbo_stream }.to change { question.files.count }.by(-1)
      end

      it "The answer's attached files are being deleted" do
        login(author_answer)

        expect { delete :destroy, params: { id: file_answer.id },
                format: :turbo_stream }.to change { answer.files.count }.by(-1)
      end
    end

    context 'another user cannot delete the file' do
      before { login(user) }

      it "The question's attached files are not deleted" do
        expect { delete :destroy, params: { id: file_question.id  },
                 format: :turbo_stream }.to_not change { question.files.count }
      end

      it "The answer's attached files are not deleted" do
        expect { delete :destroy, params: { id: file_answer.id   },
                 format: :turbo_stream }.to_not change { answer.files.count }
      end
    end
  end
end
