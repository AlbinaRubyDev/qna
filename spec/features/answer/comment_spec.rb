require 'rails_helper'

feature 'User can vote for answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'writes a comment to the answer', js: true do
      within ".answer_comments" do
        fill_in 'Comment', with: 'Test comment for answer text'
        click_on 'Send'

        expect(page).to have_content 'Test comment for answer text'
        expect(page).to have_content user.email
      end
    end

    scenario 'writes a comment to a answer with errors', js: true do
      within ".answer_comments" do
        click_on 'Send'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario "don't see a button to send a comment", js: true do
      visit question_path(question)

      within ".answer_comments" do
        expect(page).to_not have_content 'Comment'
        expect(page).to_not have_content 'Send'
      end
    end
  end
end
