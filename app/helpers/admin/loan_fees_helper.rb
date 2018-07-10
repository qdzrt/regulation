module Admin::LoanFeesHelper
  def product_options(selected=nil)
    options_for_select(Product.all.collect { |p| [ p.name, [p.period_num, p.period_unit].join ] }, selected)
  end

  def score_interval_options(selected=nil)
    options_for_select(CreditEval.all.collect { |p| [ ['[', p.score_gteq, ',', p.score_lt, ')'].join, [p.score_gteq, ',', p.score_lt].join ]}, selected)
  end

  def times_options(selected=nil)
    options_for_select([['首贷', 1], ['续贷', 2]], selected)
  end
end
