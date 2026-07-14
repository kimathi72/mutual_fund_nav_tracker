class CreateMlModels < ActiveRecord::Migration[7.1]
  def change
    create_table :ml_models do |t|

      t.string :name, null: false
      t.string :version, null: false

      t.string :framework
      t.string :algorithm

      t.string :status, default: "development"

      t.jsonb :metadata, default: {}

      t.timestamps
    end


    add_index :ml_models,
      [:name, :version],
      unique: true

  end
end