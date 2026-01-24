require 'rails_helper'

feature 'User can edit his answer', %q(
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
) do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: author) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    within 'turbo-frame#answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in(author)
      visit question_path(question)

      within 'turbo-frame#answers' do
        click_on 'Edit'
      end

      within "turbo-frame#answer_#{answer.id}" do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'
      end

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'edited answer'
    end

    scenario 'edits his answer with errors' do
      sign_in(author)
      visit question_path(question)

      within 'turbo-frame#answers' do
        click_on 'Edit'
      end

      within "turbo-frame#answer_#{answer.id}" do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question", js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_content "Edit question"
    end
  end
end
