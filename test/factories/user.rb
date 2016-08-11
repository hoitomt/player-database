FactoryGirl.define do
  sequence :email do |n|
    "test#{n}@example.com"
  end
end

FactoryGirl.define do
  factory :user do
    email { FactoryGirl.generate(:email) }
    password "Passw0rd"

    after(:create) do |instance|
      ApiKey.create(user: instance)
    end
  end
end
