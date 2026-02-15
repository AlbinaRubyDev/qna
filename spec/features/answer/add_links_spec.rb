require 'rails_helper'

feature 'User can add links to answer', %q(
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/AlbinaRubyDev/8483bc731953ac17f94b757e6050774b' }
  given(:gist_url_2) { 'https://gist.github.com/AlbinaRubyDev/56d96eb99744e125ae7be0a5270c9ea8' }
  given(:url_1) { 'https://translate.google.com/' }
  given(:url_2) { 'https://mail.google.com/' }

  scenario 'User adds link when writing a answer', js: true do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_css('turbo-frame#new_answer')

    within 'turbo-frame#new_answer' do
      fill_in 'Body', with: 'answer text text text'

      click_on 'Add link'

      fill_in 'Link name', with: 'My url'
      fill_in 'Url', with: url_1

      click_on 'Submit answer'
    end

    within 'turbo-frame#answers' do
      expect(page).to have_link 'My url', href: url_1
    end
  end

  scenario 'User adds links when writing a answer', js: true do
    sign_in(user)

    visit question_path(question)

    #временно, для отладки редко выпадающей ошибки "expected to find css 'turbo-frame#new_answer'"
    expect(page).to have_current_path(question_path(question), ignore_query: true)

    expect(page).to have_css('turbo-frame#new_answer')

    within 'turbo-frame#new_answer' do
      fill_in 'Body', with: 'answer text text text'

      click_on 'Add link'

      all('[data-link-block="true"]').last.tap do |block|
        within block do
          fill_in 'Link name', with: 'My url 1'
          fill_in 'Url', with: url_1
        end
      end

      click_on 'Add link'

      all('[data-link-block="true"]').last.tap do |block|
        within block do
          fill_in 'Link name', with: 'My url 2'
          fill_in 'Url', with: url_2
        end
      end

      click_on 'Submit answer'
    end

    expect(page).to have_css('turbo-frame#answers')

    within 'turbo-frame#answers' do
      expect(page).to have_link 'My url 1', href: url_1
      expect(page).to have_link 'My url 2', href: url_2
    end
  end

  scenario 'User adds link to a gist when writing a answer', js: true do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_css('turbo-frame#new_answer')

    within 'turbo-frame#new_answer' do
      fill_in 'Body', with: 'answer text text text'

      click_on 'Add link'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Submit answer'
    end

    within 'turbo-frame#answers' do
      expect(page).to have_content 'Hello, World!'
    end
  end

  scenario 'User adds links to a gist when writing a answer', js: true do
    sign_in(user)

    visit question_path(question)

    #временно, для отладки редко выпадающей ошибки "expected to find css 'turbo-frame#new_answer'"
    expect(page).to have_current_path(question_path(question), ignore_query: true)

    expect(page).to have_css('turbo-frame#new_answer')

    within 'turbo-frame#new_answer' do
      fill_in 'Body', with: 'answer text text text'

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

      click_on 'Submit answer'
    end

    expect(page).to have_css('turbo-frame#answers')

    within 'turbo-frame#answers' do
      expect(page).to have_content 'Hello, World!'
      expect(page).to have_content 'gist for features test'
    end
  end
end
