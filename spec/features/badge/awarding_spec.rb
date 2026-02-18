require 'rails_helper'

feature 'User can receive a award', %q(
  To get the best answer reward
  As the author of the answer
  I would like to be able to receive a reward if my answer is considered the best
) do
  given!(:author_question) { create(:user) }
  given!(:question) { create(:question, :with_badge, author: author_question) }
  given!(:author_answer) { create(:user) }
  given!(:answer) { create(:answer, question: question, author: author_answer) }

  scenario 'the user received a reward', js: true do
    sign_in(author_question)
    visit question_path(question)

    expect(author_answer.badges.count).to eq(0)

    click_on 'Choose the best answer'
    author_answer.reload

    expect(page).to have_content('This answer was chosen as the best')
    expect(author_answer.badges.count).to eq(1)
  end
end
