class LoanFeePreferential < BaseQuery
  def initialize(relation = LoanFee.all)
    @relation = relation
  end

  def call
    ActiveRecord::Base.connection.exec_query(sql).map(&:deep_symbolize_keys!)
  end

  private

  def to_query
    loan_fees
      .project(
        loan_fees[:id].as(Arel.sql 'loan_fee_id'),
        loan_fees[:times].as(Arel.sql 'times'),
        loan_fees[:management_fee].as(Arel.sql 'management_fee'),
        loan_fees[:dayly_fee].as(Arel.sql 'dayly_fee'),
        loan_fees[:weekly_fee].as(Arel.sql 'weekly_fee'),
        loan_fees[:monthly_fee].as(Arel.sql 'monthly_fee'),
        products[:name].as(Arel.sql 'product_name'),
        score_interval.as(Arel.sql 'score_interval'),
      )
      .join(credit_evals).on(loan_fees[:credit_eval_id].eq(credit_evals[:id]))
      .join(products).on(loan_fees[:product_id].eq(products[:id]))
      .where(loan_fees[:id].in(last_with_product).and(loan_fees[:active].eq(true)))
      .order(products[:period_num].asc)
  end

  def score_interval
    Arel::Nodes::NamedFunction.new 'concat', [
      Arel::Nodes.build_quoted('['),
      credit_evals[:score_gteq],
      Arel::Nodes.build_quoted(','),
      credit_evals[:score_lt],
      Arel::Nodes.build_quoted(')')
    ]
  end

  def last_with_product
    loan_fees.project(loan_fees[:id].maximum).group(loan_fees[:product_id]).where(loan_fees[:times].eq(1))
  end

  def loan_fees
    @loan_fees ||= LoanFee.arel_table
  end

  def credit_evals
    @credit_evals ||= CreditEval.arel_table
  end

  def products
    @products ||= Product.arel_table
  end
end
