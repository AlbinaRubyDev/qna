FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "MyAnswersText #{n}" }
    question { nil }
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end

    trait :with_files do
      after(:create) do |answer|
        answer.files.attach(
          io: File.open(Rails.root.join('spec/rails_helper.rb')),
          filename: 'rails_helper.rb')
          answer.files.attach(
          io: File.open(Rails.root.join('spec/spec_helper.rb')),
          filename: 'spec_helper.rb')
        end
    end
  end
end
