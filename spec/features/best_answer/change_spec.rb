require 'rails_helper'

feature 'Тут написать про выбор другого ответа', %q(
  Сюда сочинить текст
) do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Перевыбор'# , js: true do
  # sign_in(author)
  # visit question_path(question)

  # expect(page).to have_link 'This is best answer'
  # click_on 'This is best answer'

  # expect(page).to have_content "This answer was chosen as the best"
  # end
end
