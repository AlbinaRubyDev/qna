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

    scenario 'writes a answer', js: true do
      within 'turbo-frame#new_answer' do
        fill_in 'Body', with: 'answer text text text'
        click_on 'Submit answer'
      end

      expect(current_path).to eq question_path(question)
      expect(page).to have_content question.title
      expect(page).to have_content question.body

      within 'turbo-frame#answers' do
        expect(page).to have_content 'answer text text text'
      end
    end

    scenario 'writes a answer with errors', js: true do
      click_on 'Submit answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'ask a answer with attached file' do
      within 'turbo-frame#new_answer' do
        fill_in 'Body', with: 'answer text text text'

        attach_file 'File', [ "#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb" ]
        click_on 'Submit answer'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to write a answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Submit answer'
    expect(page).to have_content 'Log in to write a answer'
  end
end
