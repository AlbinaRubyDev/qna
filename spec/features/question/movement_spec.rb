require 'rails_helper'

feature 'User can follow links', %q(
  To make it easier to movement the site
  As every user
  I would like to be able to movement from a question to a list of questions and back again
) do
  given!(:question) { create(:question) }

  scenario 'open a question from the question list', js: true do
    visit questions_path
    expect(page).to have_content question.title

    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'from a question go to the list of questions', js: true do
    questions = create_list(:question, 3)

    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    click_on 'All questions'

    questions.each do |question|
      expect(page).to have_content question.title
    end

    expect(page).to have_content question.title
  end
end
