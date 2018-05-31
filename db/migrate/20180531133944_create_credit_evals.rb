class CreateCreditEvals < ActiveRecord::Migration[5.1]
  def change
    create_table :credit_evals do |t|
      t.integer :score_gteq
      t.integer :score_lt
      t.string :grade
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
