require 'rails_helper'

feature 'User can vote for question' do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes for question', js: true do
      within ".question_votes" do
        click_on '↑'
        expect(page).to have_css('.vote-rating', text: '1')
      end
    end

    scenario 'votes against question', js: true do
      within ".question_votes" do
        click_on '↓'
        expect(page).to have_css('.vote-rating', text: '-1')
      end
    end
  end

  describe 'Author' do
    scenario 'cannot see voting links for his question', js: true do
      sign_in(author)
      visit question_path(question)

      within ".question_votes" do
        expect(page).to_not have_link '↑'
        expect(page).to_not have_link '↓'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'cannot see voting links for question', js: true do
      visit question_path(question)

      within ".question_votes" do
        expect(page).to_not have_link '↑'
        expect(page).to_not have_link '↓'
      end
    end
  end
end
