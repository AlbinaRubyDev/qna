require 'rails_helper'

feature 'User can delete his question', %q(
  In order to delete question
  As an authenticated user
  I'd like to be able to delete your question
) do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: author) }

  describe 'Authenticated user' do
    scenario 'tries to delete your question' do
      sign_in(author)
      visit question_path(question)

      click_on 'Delete question'

      expect(page).to have_content 'Your question was succesfully deleted'
      expect(page).to_not have_content question.title
    end

    scenario "tries to delete someone else's question" do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to_not have_link 'Delete question'
    end

    scenario "remove your question from the list" do
      sign_in(author)
      visit questions_path

      click_on 'Delete question'

      expect(page).to have_content 'Your question was succesfully deleted'
      expect(page).to_not have_content question.title
    end

    scenario "delete someone else's question from the list" do
      sign_in(user)
      visit questions_path

      expect(page).to have_content question.title
      expect(page).to_not have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Unauthenticated user tries to delete question from the list' do
    visit questions_path

    expect(page).to_not have_link 'Delete question'
  end
end
