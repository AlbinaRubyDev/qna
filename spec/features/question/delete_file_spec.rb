require 'rails_helper'

feature 'User can delete a file attached to their question', %q(
To delete a file
As the question author
I would like to be able to delete the attached file
) do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, :with_files, author: author) }

  scenario 'Unauthorized users cannot delete files attached to the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete file'
  end

  scenario "The user is trying to delete files attached to another user's question", js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete file'
  end

  scenario 'The author deleted the file attached to his question', js: true do
    sign_in(author)
    visit question_path(question)
    file = question.files.first

    within("li", text: file.filename.to_s) do
      accept_confirm do
        click_on 'Delete file'
      end
    end

    expect(page).to_not have_link file.filename.to_s
    expect(page).to have_content question.title
  end
end
