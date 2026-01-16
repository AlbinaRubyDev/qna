require 'rails_helper'

feature 'User can sign up', %q(
  In order to ask question
  As an unauthenticated user
  I'd like to be able to sign up
) do
  background { visit new_user_registration_path }

  scenario 'Unregistred user tries to sign up', js: true do
    fill_in 'Email', with: 'username@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistred user tries to sign up but enters invalid data', js: true do
    fill_in 'Email', with: 'username'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '345678'
    click_on 'Sign up'

    expect(page).to have_content 'Email is invalid'
    expect(page).to have_content "Password confirmation doesn't match"
  end
end
