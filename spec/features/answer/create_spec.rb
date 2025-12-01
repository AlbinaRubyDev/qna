require 'rails_helper'

feature 'User can create answer', %q(
  In order to help other users
  As an authenticated user
  I'd like to be able to write an answer on the question page
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'writes a answer' do
      fill_in 'answer_body', with: 'answer text text text'
      click_on 'Submit answer'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'answer text text text'
    end

     scenario 'writes a answer with errors' do
      click_on 'Submit answer'

      expect(page).to have_content "Body can't be blank"
     end
  end

  scenario 'Unauthenticated user tries to write a answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Submit answer'
    expect(page).to have_content 'Log in to write a answer'
  end
end
