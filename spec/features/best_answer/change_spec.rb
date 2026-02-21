require 'rails_helper'

feature 'The author of the question can re-select the best answer', %q(
  To mark the best answer
  As the author of the question
  I would like to be able to re-select the best answer
) do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer1) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }

  scenario 're-select the best answer', js: true do
    question.mark_as_best(answer2)

    sign_in(author)
    visit question_path(question)

    expect(page).to have_css('turbo-frame#answers')
    
    within "turbo-frame#answers" do
      expect(page).to have_link 'Choose the best answer'
      click_on 'Choose the best answer'
    end

    expect(page).to have_content "This answer was chosen as the best"

    within "turbo-frame#best_answer" do
      expect(page).to have_content answer1.body
    end
  end
end
