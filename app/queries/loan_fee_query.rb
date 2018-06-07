class LoanFeeQuery < BaseQuery
  attr_reader :relation, :period, :times, :score

  def initialize(relation = LoanFee.all, period, times, score)
    @relation = relation
    @period = period
    @times = times
    @score = score
  end

  def call
    ActiveRecord::Base.connection.exec_query(sql).first
  end

  private

  def to_query
    loan_fees_table
      .project(
        loan_fees_table[:management_fee],
        loan_fees_table[:dayly_fee],
        loan_fees_table[:weekly_fee],
        loan_fees_table[:monthly_fee]
      )
      .join(products_table).on(join_products_conds)
      .join(credit_evals_table).on(join_credit_evals_conds)
      .where(loan_fees_table[:times].eq(times))
  end

  def join_products_conds
    if period.is_a?(Integer) || period[-1] =~ /\d+/
      period_num = period.to_i
      period_unit = 'M'
    else
      period_num = period[0..-2]
      period_unit = period[-1].upcase
    end
    loan_fees_table[:product_id].eq(products_table[:id])
      .and(products_table[:period_num].eq(period_num))
      .and(products_table[:period_unit].eq(period_unit))
      .and(products_table[:active].eq(true))
  end

  def join_credit_evals_conds
    loan_fees_table[:credit_eval_id].eq(credit_evals_table[:id])
      .and(credit_evals_table[:score_gteq].lt(score))
      .and(credit_evals_table[:score_lt].gteq(score))
  end

  def loan_fees_table
    @loan_fees_table ||= LoanFee.arel_table
  end

  def products_table
    @products_table ||= Product.arel_table
  end

  def credit_evals_table
    @credit_evals_table ||= CreditEval.arel_table
  end
end