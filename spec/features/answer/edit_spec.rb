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

      expect(page).to have_css('turbo-frame#answers')

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

    scenario 'edits his answer with attached file' do
      sign_in(author)
      visit question_path(question)

      within "turbo-frame#answer_#{answer.id}" do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'

        attach_file 'File', [ "#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb" ]
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'edits his answer with errors' do
      sign_in(author)
      visit question_path(question)

      expect(page).to have_css('turbo-frame#answers')
      
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
