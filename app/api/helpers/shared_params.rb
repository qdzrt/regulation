module SharedParams
  extend Grape::API::Helpers

  params :pagination do
    optional :page, type: Integer
    optional :per, type: Integer
  end

  params :order do |options|
    optional :order_by, type: Symbol, values: options[:order_by], default: options[:default_order_by]
    optional :order_type, type: Symbol, values: %i(asc desc), default: options[:default_order_type]
  end
end