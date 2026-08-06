FactoryBot.define do
  factory :daily_nav do
    association :mutual_fund
    nav_date { Date.current }
    nav { 100.0 }
    currency { 'USD' }
    source { 'test' }
    fetched_at { Time.current }
  end
end
