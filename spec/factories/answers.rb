FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "MyAnswersText #{n}" }
    question { nil }
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
