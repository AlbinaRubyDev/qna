require 'rails_helper'

feature 'User can add links to question', %q(
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
) do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/AlbinaRubyDev/8483bc731953ac17f94b757e6050774b' }
  given(:gist_url_2) { 'https://gist.github.com/AlbinaRubyDev/56d96eb99744e125ae7be0a5270c9ea8' }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Your question', with: 'text text text'

    click_on 'Add link'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'User adds links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Your question', with: 'text text text'

    click_on 'Add link'

    all('[data-link-block="true"]').last.tap do |block|
      within block do
        fill_in 'Link name', with: 'My gist 1'
        fill_in 'Url', with: gist_url
      end
    end

    click_on 'Add link'

    all('[data-link-block="true"]').last.tap do |block|
      within block do
        fill_in 'Link name', with: 'My gist 2'
        fill_in 'Url', with: gist_url_2
      end
    end

    click_on 'Ask'

    expect(page).to have_link 'My gist 1', href: gist_url
    expect(page).to have_link 'My gist 2', href: gist_url_2
  end
end
