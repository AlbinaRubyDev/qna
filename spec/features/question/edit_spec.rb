require 'rails_helper'

feature 'User can edit his question', %q(
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
) do
  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in(author)
      visit question_path(question)

      within '.question' do
        click_on 'Edit question'

        save_and_open_page
        fill_in 'Your question', with: 'edited question'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits the one just created'
    scenario 'edits his question with errors'
    scenario "tries to edit other user's question"
  end
end
