require 'rails_helper'

shared_examples_for "voted" do
  it "included Voted" do
    expect(described_class).to include(Voted)
  end

  describe 'PATCH #cast_vote' do
    before { login(user) }

    context 'user votes' do
      it 'creates vote +1' do
        patch :cast_vote, params: vote_params(1), format: :json

        expect(votable.votes.sum(:value)).to eq(1)
      end

      it 'creates vote -1' do
        patch :cast_vote, params: vote_params(-1), format: :json

        expect(votable.votes.sum(:value)).to eq(-1)
      end
    end

    context 'the author cannot vote' do
      it 'does NOT votes' do
        login(author)
        expect { patch :cast_vote, params: vote_params(1), format: :json }.to_not change(Vote, :count)
      end
    end
  end

  describe 'DELETE #cancel_vote' do
    before { login(user) }
    
    let!(:vote) { votable.votes.create!(user: user, value: 1) }
    
    it 'user vote has been deleted' do
      expect { delete :cancel_vote, params: { id: votable.id }, format: :json }.to change(Vote, :count).by(-1)
    end
    
    it 'rating has been recalculated' do
      delete :cancel_vote, params: { id: votable.id }, format: :json
      expect(votable.votes.sum(:value)).to eq(0)
    end
  end
end
