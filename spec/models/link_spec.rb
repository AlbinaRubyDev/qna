require 'rails_helper'

RSpec.describe Link, type: :model do
  subject { build(:link, linkable: build(:question)) }

  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value('https://www.google.com/').for(:url)}
  it { should_not allow_value('https:/google').for(:url)}
  it { should_not allow_value('oogle.com/').for(:url)}
  it { should_not allow_value('https.com/').for(:url)}

  describe "gist?" do
    it "return false for link example" do
      link = build(:link)
      expect(link.gist?).to be false
    end

    it "return true for link gist.github.com" do
      link = build(:link, :for_gist)
      expect(link.gist?).to be true
    end
  end
end
