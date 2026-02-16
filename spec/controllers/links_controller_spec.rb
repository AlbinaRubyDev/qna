require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    let!(:author_question) { create(:user) }
    let!(:question) { create(:question, :with_links, author: author_question) }
    let(:link_question) { question.links.first }

    let!(:author_answer) { create(:user) }
    let!(:answer) { create(:answer, :with_links, question: question, author: author_answer) }
    let(:link_answer) { answer.links.first }

    context "author deletes file" do
      it "The question's attached links are being deleted" do
        login(author_question)

        expect { delete :destroy, params: { id: link_question.id },
                format: :turbo_stream }.to change { question.links.count }.by(-1)
      end

      it "The answer's attached links are being deleted" do
        login(author_answer)

        expect { delete :destroy, params: { id: link_answer.id },
                format: :turbo_stream }.to change { answer.links.count }.by(-1)
      end
    end

    context 'another user cannot delete the link' do
      before { login(user) }

      it "The question's attached links are not deleted" do
        expect { delete :destroy, params: { id: link_question.id  },
                 format: :turbo_stream }.to_not change { question.links.count }
      end

      it "The answer's attached links are not deleted" do
        expect { delete :destroy, params: { id: link_answer.id   },
                 format: :turbo_stream }.to_not change { answer.links.count }
      end
    end
  end
end
