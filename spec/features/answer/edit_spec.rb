require 'rails_helper'

feature 'User can edit his answer', %q(
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
) do
  given(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: author) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in(author)
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits the one just created', js: true do
      sign_in(author)
      visit question_path(question)

        # within '.new-answer' do
        find('#new_answer_body').set('answer bug fix')
        click_on 'Submit answer'
      # end

      new_answer = nil
      within '.answers' do
        expect(page).to have_content 'answer bug fix'
        new_answer = Answer.order(:created_at).last
      end

      within %(.answer[data-answer-id="#{new_answer.id}"]) do
        click_on 'Edit'

        expect(page).to have_selector("#edit_answer_body_#{new_answer.id}")

        find("#edit_answer_body_#{new_answer.id}").set('there are no errors')
        click_on 'Save'

        expect(page).to have_content 'there are no errors'
        expect(page).to_not have_content 'answer bug fix'
      end
    end

    scenario 'edits his answer with errors', js: true do
      sign_in(author)
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question" do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_content 'Edit'
      end
    end
  end
