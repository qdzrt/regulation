module ApplicationHelper
  def period_unit_options
    options_for_select(Product.period_unit_title, 'M')
  end
end
