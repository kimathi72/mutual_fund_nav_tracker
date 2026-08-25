class CreateDailyNavs < ActiveRecord::Migration[7.1]
  def change
    create_table :daily_navs do |t|
      t.references :mutual_fund,
                   null: false,
                   foreign_key: true

      t.date :nav_date, null: false

      t.decimal :nav,
                precision: 15,
                scale: 6,
                null: false

      t.string :currency, null: false

      t.string :source,
               null: false,
               default: "yahoo_finance"

      t.datetime :fetched_at, null: false

      t.jsonb :raw_payload

      t.timestamps
    end

    add_index :daily_navs,
              [:mutual_fund_id, :nav_date],
              unique: true

    add_index :daily_navs, :nav_date
    add_index :daily_navs, :fetched_at
    add_index :daily_navs, :source

    add_index :daily_navs,
              :raw_payload,
              using: :gin
  end
end