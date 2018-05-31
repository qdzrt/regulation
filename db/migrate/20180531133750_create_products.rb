class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :period_num
      t.string :period_unit
      t.references :user, foreign_key: true
      t.boolean :active, default: false

      t.timestamps
    end
    add_index :products, :name
  end
end
