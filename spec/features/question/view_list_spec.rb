require 'rails_helper'

feature 'User can view list of questions', %q(
  In order to find interesting questions
  As every user
  I'd like to be able to see all questions
) do
  given!(:questions) { create_list(:question, 3) }

  scenario 'Authenticated user view list of questions', js: true do
    user = create(:user)
    sign_in(user)
  end

  scenario 'Unauthenticated user view list of questions', js: true do
  end

  after do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
