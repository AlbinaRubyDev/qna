FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { 'с0mp!3xpa$$w0rdf0rTh3Pa$$w0rdManag3r' }
    password_confirmation { 'с0mp!3xpa$$w0rdf0rTh3Pa$$w0rdManag3r' }
  end
end
