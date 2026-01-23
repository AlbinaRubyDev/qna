require 'rails_helper'

feature 'Тут написать про выбор лучшего ответа', %q(
  Сюда сочинить текст
) do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'The author can choose the answer as the best.', js: true do
    sign_in(author)
    visit question_path(question)

    expect(page).to have_link 'This is best answer'
    click_on 'This is best answer'

    expect(page).to have_content "This answer was chosen as the best."
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
