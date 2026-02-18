FactoryBot.define do
  factory :question do
    title { "MyQuestionString" }
    body { "MyQuestionText" }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end

    trait :with_files do
      after(:create) do |question|
        question.files.attach(
          io: File.open(Rails.root.join('spec/rails_helper.rb')),
          filename: 'rails_helper.rb')
       question.files.attach(
          io: File.open(Rails.root.join('spec/spec_helper.rb')),
          filename: 'spec_helper.rb')
      end
    end

    trait :with_badge do
      after(:create) do |question|
        create(:badge, question: question)
      end
    end
  end
end
