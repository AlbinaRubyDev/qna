require 'rails_helper'

feature 'User can create a award', %q(
  To reward the best answer
  As the author of the question
  I would like to be able to create a bounty when creating a question
) do
  given(:user) { create(:user) }


  scenario 'create a award', js: true do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'

    within 'turbo-frame#new_question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Your question', with: 'text text text'

      fill_in 'Title badge', with: 'This is the best answer, thank you!'
      attach_file 'Image', "#{Rails.root}/image_for_test.jpg"

      click_on 'Ask'
    end

    expect(page).to have_css('img')
  end
end
