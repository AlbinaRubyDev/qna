require 'rails_helper'

feature 'User can delete his answer', %q(
  In order to delete answer
  As an authenticated user
  I'd like to be able to delete your answer
) do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: author) }

  describe 'Authenticated user' do
    scenario 'tries to delete your answer', js: true do
      sign_in(author)
      visit question_path(question)

      within "turbo-frame#answers" do
        expect(page).to have_content answer.body

        # save_and_open_page
        accept_confirm do
          click_on 'Delete answer'
        end
      end

      # save_and_open_page
      expect(page).to have_content 'Your answer was succesfully deleted'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to_not have_content answer.body
    end

    scenario "tries to delete someone else's answer", js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end
