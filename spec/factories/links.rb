FactoryBot.define do
  factory :link do
    name { "MyLink" }
    url { "https://example.com" }

    linkable { nil }

    trait :for_gist do
      name { "My gist" }
      url { "https://gist.github.com/AlbinaRubyDev/8483bc731953ac17f94b757e6050774b" }
    end
  end
end
