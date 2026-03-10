require 'rails_helper'

feature 'User can vote for answer' do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: author) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes for answer', js: true do
      within "turbo-frame#answer_#{answer.id}" do
        click_on '↑'
        expect(page).to have_css('.vote-rating', text: '1')
      end
    end

    scenario 'votes against answer', js: true do
      within "turbo-frame#answer_#{answer.id}" do
        click_on '↓'
        expect(page).to have_css('.vote-rating', text: '-1')
      end
    end

    scenario 'user is trying to vote for a answer again, although they have already voted +1', js: true do
      within "turbo-frame#answer_#{answer.id}" do
        click_on '↑'
        expect(page).to have_css('.vote-rating', text: '1')

        click_on '↑'
        expect(page).to have_css('.vote-rating', text: '1')

        click_on '↓'
        expect(page).to have_css('.vote-rating', text: '1')
      end
    end

    scenario 'user is trying to vote for a answer again, although they have already voted -1', js: true do
      within "turbo-frame#answer_#{answer.id}" do
        click_on '↓'
        expect(page).to have_css('.vote-rating', text: '-1')

        click_on '↓'
        expect(page).to have_css('.vote-rating', text: '-1')

        click_on '↑'
        expect(page).to have_css('.vote-rating', text: '-1')
      end
    end
  end

  describe 'Author' do
    scenario 'cannot see voting links for his answer', js: true do
      sign_in(author)
      visit question_path(question)

      within "turbo-frame#answer_#{answer.id}" do
        expect(page).to_not have_link '↑'
        expect(page).to_not have_link '↓'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'cannot see voting links for answer', js: true do
      visit question_path(question)

      within "turbo-frame#answer_#{answer.id}" do
        expect(page).to_not have_link '↑'
        expect(page).to_not have_link '↓'
      end
    end
  end
end
