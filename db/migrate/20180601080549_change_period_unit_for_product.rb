class ChangePeriodUnitForProduct < ActiveRecord::Migration[5.1]
  def change
    change_column :products, :period_unit, :integer, default: 1
  end
end
