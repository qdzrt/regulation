class ProductFeeIntervalQuery < BaseQuery
  attr_reader :relation, :period, :times

  def initialize(relation = LoanFee.all, period, times)
    @relation = relation
    @period = period
    @times = times
  end

  def call
    ActiveRecord::Base.connection.exec_query(sql).first.to_hash
  end

  private

  def to_query
    relation
      .select(
        loan_fees_table[:management_fee].minimum.as('min_management_fee'),
        loan_fees_table[:management_fee].maximum.as('max_management_fee'),
        loan_fees_table[:dayly_fee].minimum.as('min_dayly_fee'),
        loan_fees_table[:dayly_fee].maximum.as('max_dayly_fee'),
        loan_fees_table[:weekly_fee].minimum.as('min_weekly_fee'),
        loan_fees_table[:weekly_fee].maximum.as('max_weekly_fee'),
        loan_fees_table[:monthly_fee].minimum.as('min_monthly_fee'),
        loan_fees_table[:monthly_fee].maximum.as('max_monthly_fee')
      )
      .joins(loan_fees_table.join(products_table).on(join_product_conds).join_sources)
      .where(loan_fees_table[:active].eq(true).and(loan_fees_table[:times].eq(times)))
  end

  def join_product_conds
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
  end

  def loan_fees_table
    @loan_fees_table ||= LoanFee.arel_table
  end

  def products_table
    @products_table ||= Product.arel_table
  end
end
