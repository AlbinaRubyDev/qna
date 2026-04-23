require 'rails_helper'

feature 'User can sign in', %q(
  In order to ask question
  As an unauthenticated user
  I'd like to be able to sign in
) do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registred user tries to sign in', js: true do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistred user tries to sign in', js: true do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario 'User signs in with GitHub', js: true do
    mock_auth_hash(:github)

    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Successfully authenticated from Github account.'
  end
end
