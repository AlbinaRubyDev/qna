require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).with_foreign_key(:author_id).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:badges).dependent(:destroy) }
  it { should have_many(:questions).with_foreign_key(:author_id).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'add badge to the user' do
    user = create(:user)

    question = create(:question, :with_badge)

    expect { user.add_badge(question.badge) }.to change { user.badges.count }.by(1)
    expect(user.badges).to include(question.badge)
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
