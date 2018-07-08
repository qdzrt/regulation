module ApplicationHelper
  FLASH_CSS_MAP = {
    notice: 'alert alert-dismissible alert-success',
    info: 'alert alert-dismissible alert-info',
    warning: 'alert alert-dismissible alert-warning',
    error: 'alert alert-dismissible alert-danger',
  }

  def period_unit_options
    options_for_select(Product.period_unit_title, 'M')
  end

  def flash_css(type)
    FLASH_CSS_MAP[type.to_sym]
  end

  def user_status(status)
    content_tag :span, User::STATUS[status.to_s.to_sym], class: status ? %w(label label-success) : %w(label label-default)
  end

  def page_title(title)
    content_for(:title) { title.to_s }
  end
end
