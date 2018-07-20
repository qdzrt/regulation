module ApplicationHelper
  FLASH_CSS_MAP = {
    notice: 'alert alert-dismissible alert-success',
    info: 'alert alert-dismissible alert-info',
    warning: 'alert alert-dismissible alert-warning',
    error: 'alert alert-dismissible alert-danger',
  }

  LABEL_CSS_MAP = {
    success: %w(label label-success),
    default: 'label label-default',
    primary: 'label label-primary',
    info: 'label label-info',
    warning: 'label label-warning',
    danger: 'label label-danger',
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

  def current_controller?(*ctrs)
    ctrs.any? {|ctr| ctr.to_s == controller_path }
  end

  def current_action?(*acs)
    acs.any? {|ac| ac.to_s == action_name }
  end

  def select_page(controllers, actions)
    if actions && controllers
      current_controller?(controllers) && current_action?(actions)
      # current_page?(controller: controller_path, action: action)
    else
      current_controller?(controllers) || current_action?(actions)
    end
   end

  def content_wrap(option)
    controllers = option[:controller]
    actions = option[:action]
    'active' if select_page(controllers, actions)
  end

  def lable_times(times)
    content_tag :span, times, class: "label label-#{times == '首贷' ? 'primary' : 'info'}"
  end

end
