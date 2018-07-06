class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :code, index: true
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
