require 'rails_helper'

feature 'User can view the question and answers to it', %q(
  To find out how to solve the problem
  As every user
  I'd like to be able to see the question and answers to it
) do
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'User view the question and answers to it' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
