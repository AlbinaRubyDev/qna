require 'rails_helper'

feature 'The user can view their awards', %q(
  To view your awards
  As the author of the answer
  I would like to go to a page with all my awards
) do
  given!(:author_question) { create(:user) }
  given!(:question) { create(:question, :with_badge, author: author_question) }
  given!(:author_answer) { create(:user) }
  given!(:answer) { create(:answer, question: question, author: author_answer) }

  scenario 'the user can view their awards', js: true do
    sign_in(author_question)
    visit question_path(question)

    click_on 'Choose the best answer'
    author_answer.reload

    expect(page).to have_content('This answer was chosen as the best')

    click_on 'Log out'
    expect(page).to have_content('Signed out successfully')

    sign_in(author_answer)
    visit question_path(question)

    click_on 'My awards'

    expect(page).to have_content('All my awards')
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.badge.title)
    expect(page).to have_css('img')
  end
end
