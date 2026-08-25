FactoryBot.define do
  factory :mutual_fund do
    name { Faker::Company.unique.name }

    sequence(:isin) do |n|
      "LU#{format('%010d', n)}"
    end

    currency { "USD" }

    domicile { "Luxembourg" }

    fund_house { "Factory Fund House" }

    active { true }
  end
end