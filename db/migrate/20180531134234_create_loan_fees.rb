class CreateLoanFees < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_fees do |t|
      t.references :credit_eval, foreign_key: true
      t.references :product, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :times
      t.decimal :management_fee, precision: 3, scale: 2
      t.decimal :dayly_fee, precision: 3, scale: 2
      t.decimal :weekly_fee, precision: 3, scale: 2
      t.decimal :monthly_fee, precision: 3, scale: 2
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
