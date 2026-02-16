require 'rails_helper'

feature 'User can delete a link attached to their question', %q(
To delete a link
As the question author
I would like to be able to delete the attached link
) do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, :with_links, author: author) }

  scenario 'Unauthorized users cannot delete links attached to the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete link'
  end

  scenario "The user is trying to delete links attached to another user's question", js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete link'
  end

  scenario 'The author deleted the links attached to his question', js: true do
    sign_in(author)
    visit question_path(question)
    link = question.links.first

    within("li", text: link.name.to_s) do
      accept_confirm do
        click_on 'Delete link'
      end
    end

    expect(page).to_not have_link link.name.to_s
    expect(page).to have_content question.title
  end
end
