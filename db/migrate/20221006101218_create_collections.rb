class CreateCollections < ActiveRecord::Migration[6.1]
  def change
    create_table :collections do |t|

      t.integer :user_id, null: false
      t.string :sake_name, null: false
      t.integer :remain_amount, default: 0
      t.integer :tastes_rich, default: 0
      t.integer :tastes_sweet, default: 0
      t.integer :is_aromatic, default: 0
      t.datetime :open_date

      t.timestamps
    end
  end
end
