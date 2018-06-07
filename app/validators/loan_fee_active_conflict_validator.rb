class LoanFeeActiveConflictValidator < ActiveModel::Validator
  def validate(record)
    if record[:active] && !Product.find(record[:product_id]).try(:active)
      record.errors.add :active, '该产品未激活'
    end
  end
end