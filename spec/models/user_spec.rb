require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).with_foreign_key(:author_id).dependent(:destroy) }
  it { should have_many(:answers).with_foreign_key(:author_id).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end
