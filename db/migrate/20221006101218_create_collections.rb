class CreateCollections < ActiveRecord::Migration[6.1]
  def change
    create_table :collections do |t|

      t.integer :user_id, null: false
      t.string :sake_name, null: false
      t.integer :remain_amount, default: 0
      t.boolean :tastes_rich, default: true
      t.boolean :tastes_sweet, default: true
      t.boolean :is_aromatic, default: true

      t.timestamps
    end
  end
end
