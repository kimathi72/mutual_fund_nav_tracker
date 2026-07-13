FactoryBot.define do
  factory :executive_briefing do
    as_of_date { "2026-07-13" }
    provider { "MyString" }
    model { "MyString" }
    status { "MyString" }
    briefing { "MyText" }
    prompt { "MyText" }
    error { "MyText" }
    generated_at { "2026-07-13 16:43:45" }
  end
end
