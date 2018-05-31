class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.boolean :active, default: false

      t.timestamps
    end
    add_index :users, :name
  end
end
