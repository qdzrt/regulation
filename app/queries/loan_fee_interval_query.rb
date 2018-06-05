# frozen_string_literal: true

class LoanFeeIntervalQuery < BaseQuery

  MIN_FEE = 0

  def initialize
  end

  def call
    ActiveRecord::Base.connection.exec_query(sql).map(&:symbolize_keys)
  end

  private

  def to_query
    products_table
      .project(
        subquery[:period_num],
        Arel::Nodes::NamedFunction.new('least', [subquery[:min_dayly_fee], subquery[:min_weekly_fee], subquery[:min_monthly_fee]]).as('min_fee'),
        Arel::Nodes::NamedFunction.new('greatest', [subquery[:max_dayly_fee], subquery[:max_weekly_fee], subquery[:max_monthly_fee]]).as('max_fee')
      ).from(subquery)
  end

  def subquery
    products_table
      .project(
        products_table[:period_num],
        d_table[:dayly_fee].minimum.as('min_dayly_fee'),
        loan_fees_table[:dayly_fee].maximum.as('max_dayly_fee'),
        loan_fees_table[:weekly_fee].minimum.as('min_weekly_fee'),
        loan_fees_table[:weekly_fee].maximum.as('max_weekly_fee'),
        loan_fees_table[:monthly_fee].minimum.as('min_monthly_fee'),
        loan_fees_table[:monthly_fee].maximum.as('max_monthly_fee')
      )
      .join(loan_fees_table).on(products_table[:id].eq(loan_fees_table[:product_id]))
      .join(d_table).on(products_table[:id].eq(d_table[:product_id]).and(d_table[:dayly_fee].gt(MIN_FEE)))
      .where(products_table[:active].eq(true))
      .group(products_table[:id])
      .as(Arel.sql('subquery'))
  end

  def d_table
    loan_fees_table.alias('d_table')
  end

  def loan_fees_table
    @loan_fees_table ||= LoanFee.arel_table
  end

  def products_table
    @products_table ||= Product.arel_table
  end
end