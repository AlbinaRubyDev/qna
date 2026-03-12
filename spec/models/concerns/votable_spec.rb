require 'rails_helper'

shared_examples_for "votable" do
  let(:user) { create(:user) }

  it { should have_many(:votes).dependent(:destroy) }

  describe 'user_voted?' do
    it 'returns true if user voted' do
      vote = create(:vote, user: user, votable: subject)
      expect(subject.user_voted?(user)).to be true
    end
  
    it 'returns false if user not voted' do
      expect(subject.user_voted?(user)).to be false
    end
  end
end
