FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question { nil }
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
