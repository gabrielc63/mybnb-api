FactoryBot.define do
  factory :booking do
    association :user
    association :listing
    start_date { Date.tomorrow }
    end_date { Date.tomorrow + 3.days }
    number_of_guests { 2 }
    special_requests { 'Late check-in requested' }
    status { :pending }

    trait :confirmed do
      status { :confirmed }
    end

    trait :cancelled do
      status { :cancelled }
    end

    trait :completed do
      start_date { 1.week.ago }
      end_date { 4.days.ago }
      status { :completed }
    end
  end
end
