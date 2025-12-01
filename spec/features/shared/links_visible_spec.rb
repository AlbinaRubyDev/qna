require 'rails_helper'

feature 'User can see links', %q(
  In order to use the account
  As a user
  I'd like to see sign in/sign up/sign out links
) do
  given(:question) { create(:question) }

  scenario 'Authenticated user see sign out links' do
    user = create(:user)
    sign_in(user)

    visit root_path

    expect(page).to have_link 'Log out'
    expect(page).to_not have_link 'Sign in'

    visit questions_path

    expect(page).to have_link 'Log out'
    expect(page).to_not have_link 'Sign in'

    visit question_path(question)

    expect(page).to have_link 'Log out'
    expect(page).to_not have_link 'Sign in'
  end


  scenario 'Unauthenticated user see sign in/sign up links' do
    visit root_path

    expect(page).to_not have_link 'Log out'
    expect(page).to have_link 'Sign in'

    visit questions_path

    expect(page).to_not have_link 'Log out'
    expect(page).to have_link 'Sign in'

    visit question_path(question)

    expect(page).to_not have_link 'Log out'
    expect(page).to have_link 'Sign in'
  end
end
