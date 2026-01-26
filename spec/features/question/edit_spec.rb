require 'rails_helper'

feature 'User can edit his question', %q(
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
) do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: author) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in(author)
      visit question_path(question)

      click_on 'Edit question'

      fill_in 'Your question', with: 'edited question'
      click_on 'Save'

      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question'
    end

    scenario 'edits his question with attached file' do
      sign_in(author)
      visit question_path(question)

      click_on 'Edit question'

      fill_in 'Your question', with: 'edited question'

      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Save'

      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'edits his question with errors title' do
      sign_in(author)
      visit question_path(question)

      click_on 'Edit question'

      fill_in 'Title', with: ''
      click_on 'Save'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'edits his question with errors body' do
      sign_in(author)
      visit question_path(question)

      click_on 'Edit question'

      fill_in 'Your question', with: ''
      click_on 'Save'

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question", js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_content "Edit question"
    end
  end
end
