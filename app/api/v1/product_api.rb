module V1
  class ProductAPI < Grape::API
    resource :products do
      helpers SharedParams

      before do
        authenticate!

        def permitted_params
          @permitted_params ||= declared(params, include_missing: false).to_h
        end
      end

      desc 'Get all products'
      params do
        use :order, order_by: %i(id), default_order_by: :id, default_order_type: :asc
      end
      get do
        products = Product.all
        present :products, products, with: API::Entities::ProductEntity
      end

      desc 'Return a product'
      params do
        requires :id, type: Integer, desc: 'product id'
      end
      route_param :id do
        get do
          Product.find(params[:id])
        end
      end

      desc 'Create a product'
      params do
        requires :name, type: String, desc: 'product name'
        requires :period_num, type: Integer, desc: 'product period_num'
        requires :period_unit, type: String, desc: 'product period_unit'
      end
      post do
        Product.create!(permitted_params.merge({user: current_user, active: true}))
      end

      desc 'Update a product'
      params do
        requires :id, type: Integer, desc: 'product id'
        optional :name, type: String, desc: 'product name'
        optional :period_num, type: Integer, desc: 'product period_num'
        optional :period_unit, type: String, desc: 'product period_unit'
        optional :active, type: Boolean, desc: 'product active'
        at_least_one_of :name, :period_num, :period_unit, :actived
      end
      put ':id' do
        product = Product.find(params[:id])
        product.update!(permitted_params)
        product.update!(user: current_user)
      end
    end
  end
end