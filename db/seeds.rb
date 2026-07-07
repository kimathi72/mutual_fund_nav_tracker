require "yaml"

puts "🌱 Seeding Mutual Funds..."

funds = YAML.load_file(Rails.root.join("db/seeds/mutual_funds.yml"))

funds.each do |attributes|
  fund = MutualFund.find_or_initialize_by(isin: attributes["isin"])

  fund.assign_attributes(
    name: attributes["name"],
    currency: attributes["currency"],
    domicile: attributes["domicile"],
    fund_house: attributes["fund_house"],
    active: attributes["active"]
  )

  fund.save!
end

puts "✅ Seed complete!"
puts "Total Funds: #{MutualFund.count}"