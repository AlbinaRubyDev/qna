FactoryBot.define do
  factory :badge do
    title { "This is the best answer, thank you!" }

    after(:build) do |badge|
      badge.image.attach(
        io: File.open(Rails.root.join("image_for_test.jpg")),
        filename: "image_for_test.jpg"
      )
    end
  end
end
