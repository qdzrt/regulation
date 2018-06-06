module Validators
  class Period < Grape::Validations::Base
    def validate_param!(attr_name, params)
      unless params[attr_name][-1] =~ /(M|D|Y|m|d|y)/ || params[attr_name][-1] =~ /\d/
        fail Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: 'must be any one of M,D or Y'
      end
    end
  end
end