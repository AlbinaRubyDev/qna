require 'rails_helper'

feature 'User can sign out', %q(
  In order to finish session
  As an authenticated user
  I'd like to be able to sign out
) do
  given(:user) { create(:user) }

  scenario 'Authenticated user tries to sign out', js: true do
    sign_in(user)

    visit questions_path
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
