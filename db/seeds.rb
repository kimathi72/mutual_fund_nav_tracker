# require "yaml"

# puts "🌱 Seeding Mutual Funds..."

# funds = YAML.load_file(Rails.root.join("db/seeds/mutual_funds.yml"))

# funds.each do |attributes|
#   fund = MutualFund.find_or_initialize_by(isin: attributes["isin"])

#   fund.assign_attributes(
#     name: attributes["name"],
#     currency: attributes["currency"],
#     domicile: attributes["domicile"],
#     fund_house: attributes["fund_house"],
#     active: attributes["active"]
#   )

#   fund.save!
# end

# puts "✅ Seed complete!"
# puts "Total Funds: #{MutualFund.count}"

MlModel.find_or_create_by!(
  name: "NAV Forecast Model",
  version: "xgboost-v1"
) do |model|

  model.framework = "scikit-learn"
  model.algorithm = "XGBoost"

  model.status = "champion"

  model.metadata =
  {
    features:
    [
      "nav",
      "daily_return",
      "weekly_return",
      "monthly_return",
      "volatility_30",
      "moving_average_7",
      "moving_average_30",
      "drawdown"
    ],

    target:
      "next_day_nav"
  }

end