# frozen_string_literal: true

class CreateExecutiveBriefings < ActiveRecord::Migration[7.1]
  def change
    create_table :executive_briefings do |t|
      t.date :as_of_date, null: false

      t.string :provider, null: false
      t.string :model, null: false
      t.string :status, null: false, default: "success"

      t.text :prompt
      t.text :briefing
      t.text :error

      t.datetime :generated_at, null: false

      t.timestamps
    end

    add_index(
      :executive_briefings,
      %i[as_of_date provider model],
      unique: true,
      name: "idx_executive_briefings_unique"
    )

    add_index :executive_briefings, :generated_at
  end
end