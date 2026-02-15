require 'rails_helper'

feature 'User can delete his best answer', %q(
  In order to delete best answer
  As an authenticated user
  I'd like to be able to delete your best answer
) do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: author) }

  before do
    question.mark_as_best(answer)
  end

  describe 'Authenticated user' do
    scenario 'tries to delete your answer', js: true do
      sign_in(author)

      #временно, для отладки редко выпадающей ошибки "expected to find css 'turbo-frame#best_answer'"
      expect(question.reload.best_answer).to be_present

      visit question_path(question)

      #временно, для отладки редко выпадающей ошибки "expected to find css 'turbo-frame#best_answer'"
      expect(page).to have_current_path(question_path(question), ignore_query: true)

      expect(page).to have_css('turbo-frame#best_answer')

      within "turbo-frame#best_answer" do
        expect(page).to have_content answer.body
        expect(page).to have_link 'Delete answer'

        accept_confirm do
          click_on 'Delete answer'
        end
      end

      expect(page).to have_content 'Your answer was succesfully deleted'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to_not have_content answer.body
    end
  end
end
