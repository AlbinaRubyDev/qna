require 'rails_helper'

RSpec.describe BadgesController, type: :controller do
  let(:current_user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'GET #index' do
    let!(:current_questions) { create_list(:question, 3) }
    let!(:other_questions) { create_list(:question, 3) }

    let!(:current_badges) do
      current_questions.map do |q|
        create(:badge, question: q)
      end
    end

    let!(:other_badges) do
      other_questions.map do |q|
        create(:badge, question: q)
      end
    end

    before do
      current_badges.each do |badge|
        current_user.add_badge(badge)
      end

      other_badges.each do |badge|
        other_user.add_badge(badge)
      end

      login(current_user)
      get :index
    end

    context 'current user sees his awards' do
      it 'populates an array of all badges' do
        expect(assigns(:badges)).to match_array(current_badges)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context "current user does not see other people's awards" do
      it 'other users badges' do
        other_badges.each do |badge|
          expect(assigns(:badges)).not_to include(badge)
        end
      end
    end
  end
end
