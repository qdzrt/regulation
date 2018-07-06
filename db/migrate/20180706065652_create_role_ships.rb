class CreateRoleShips < ActiveRecord::Migration[5.2]
  def change
    create_table :role_ships do |t|
      t.references :roleable, polymorphic: true
      t.references :role, foreign_key: true, index: true

      t.timestamps
    end
  end
end
