FactoryBot.define do
  factory :booking do
    start_date { "2025-01-23 00:36:31" }
    end_date { "2025-01-23 00:36:31" }
    guests_amount { 1 }
    special_requests { "MyString" }
    status { 1 }
    final_price { "9.99" }
    user { nil }
    listing { nil }
  end
end
