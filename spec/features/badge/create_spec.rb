require 'rails_helper'

feature 'текст', %q(
  текст
  текст
  текст
) do
  given(:user) { create(:user) }

  describe 'текст' do
    scenario 'текст', js: true do
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
end
