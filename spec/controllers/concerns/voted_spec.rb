require 'rails_helper'

shared_examples_for "voted" do
  it "included Voted" do
    expect(described_class).to include(Voted)
  end

  describe 'PATCH #cast_vote' do
    before { login(user) }

    context 'user votes for' do
      it 'creates vote +1' do
        patch :cast_vote, params: vote_params(1), format: :json

        expect(votable.reload.votes.sum(:value)).to eq(1)
      end
    end

    context 'user votes against' do
      it 'creates vote -1' do
        patch :cast_vote, params: vote_params(-1), format: :json

        expect(votable.votes.sum(:value)).to eq(-1)
      end
    end
  end
end
