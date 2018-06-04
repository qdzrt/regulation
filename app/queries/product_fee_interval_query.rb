class ProductFeeIntervalQuery
  attr_reader :relation, :params

  def initialize(relation = LoanFee.all, params)
    @relation = relation
    @params = params
  end

  def call
    ActiveRecord::Base.connection.execute(to_sql).first
  end

  def to_sql
    to_query.to_sql
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
        loan_fees_table[:monthly_fee].maximum.as('max_monthly_fee'),
      )
      .joins(loan_fees_table.join(products_table).on(join_product_conds).join_sources)
      .where(loan_fees_table[:active].eq(true).and(loan_fees_table[:times].eq(params[:loan_times])))
  end

  def join_product_conds
    num = params[:product_period][/\d+/].to_i
    unit = case params[:product_period][-1]
             when String
               params[:product_period][-1].upcase
             when Integer
               'M'
           end
    loan_fees_table[:product_id].eq(products_table[:id])
      .and(products_table[:period_num].eq(num))
      .and(products_table[:period_unit].eq(unit))
  end

  def loan_fees_table
    @loan_fees_table ||= LoanFee.arel_table
  end

  def products_table
    @products_table ||= Product.arel_table
  end
end