class LoanFeeUniqValidator < ActiveModel::Validator
  def validate(record)
    if record.new_record? && record.class.exists?(product_id: record[:product_id], credit_eval_id: record[:credit_eval_id], times: record[:times])
      record.errors.add :loan_fee, '该类型费率已存在'
    end
  end
end