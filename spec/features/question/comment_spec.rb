require 'rails_helper'

feature 'User can vote for question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'writes a comment to the question', js: true do
      within ".question_comments" do
        fill_in 'Comment', with: 'Test comment text'
        click_on 'Send'

        expect(page).to have_content 'Test comment text'
        expect(page).to have_content user.email
      end
    end

    scenario 'writes a comment to a question with errors', js: true do
      click_on 'Send'

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario "don't see a button to send a comment", js: true do
      visit question_path(question)

      within ".question_comments" do
        expect(page).to_not have_content 'Comment'
        expect(page).to_not have_content 'Send'
      end
    end
  end
end
