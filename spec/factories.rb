FactoryGirl.define do
  factory :location do
    name { Faker::Address.street_address }
    description { Faker::Company.bs }
    lat { (SecureRandom.random_number * 180) - 90 }
    long { (SecureRandom.random_number * 360) - 180 }
  end

  factory :caller do
    phone_number { Faker::PhoneNumber.phone_number }
  end

  factory :call do
    location
    association :caller, factory: :caller
    source { Faker::PhoneNumber.phone_number }
    consented_to_callback { [true, false].sample }
  end

  factory :voice_file do
    short_name { Faker::Name.name }
    url { "#{Faker::Internet.http_url}/#{short_name}" }
  end

  factory :question do
    short_name { Faker::Name.name }
    question_text { "#{Faker::Company.bs}?" }
    feedback_type { %w(numerical_response voice_file).sample }

    trait :numerical_response do
      feedback_type 'numerical_response'
    end

    trait :voice_file do
      feedback_type 'voice_file'
    end
  end

  factory :answer do
    ignore do
      numerical_response { rand(2) }
    end

    call

    trait :voice_file do
      question { create(:question, :voice_file) }
      voice_file_url { Faker::Internet.http_url }
    end

    trait :numerical_response do
      question { create(:question, :numerical_response) }
      choice { create(:choice, number: numerical_response) }
    end
  end

  factory :subscriber do
    email { Faker::Internet.email }
  end

  factory :location_subscription do
    location
    subscriber

    trait :confirmed do
      confirmed true
    end

    trait :bulk_added do
      bulk_added true
    end
  end

  factory :choice do
    name { Faker::Name.first_name }
    number { rand(2) }
  end
end
