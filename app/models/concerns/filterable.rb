module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params = {})
      # filtering = filtering_params_order(filtering_params)
      # filtering.deep_symbolize_keys!
      filtering_params.inject(all) do |relation, (scope, value)|
        if value.present? && scope == :order
          relation.public_send(value[:order_type], value[:order_by])
        elsif value.present?
          relation.public_send(scope, value)
        else
          relation
        end
      end
    end

    private

    def filtering_params_order(filtering_params)
      filtering_params.inject({}) do |h, (k, v)|
        if k =~ /order/
          h['order'] = h['order'] ? h['order'].merge({"#{k}" => v}) : {"#{k}" => v}
        else
          h[k] = v
        end
        h
      end
    end
  end

end