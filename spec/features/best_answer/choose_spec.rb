require 'rails_helper'

feature 'The author of the question can mark the answer as the best', %q(
  To mark the best answer
  As the author of the question
  I would like to be able to choose the best answer
) do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'The author can choose the answer as the best.', js: true do
    sign_in(author)
    visit question_path(question)

    expect(page).to have_link 'Choose the best answer'
    click_on 'Choose the best answer'

    expect(page).to have_content "This answer was chosen as the best"
  end

  scenario 'Other user cannot select an answer as the best one', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'This is best answer'
  end

  scenario 'Unauthenticated user cannot select an answer as the best one', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'This is best answer'
    expect(page).to have_content 'Log in to write a answer'
  end
end
