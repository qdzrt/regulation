module V1
  class ProductAPI < Grape::API
    resource :products do
      before do
        # authenticate!
        def current_user
          User.first
        end
        def permitted_params
          @permitted_params ||= declared(params, include_missing: false).to_h
        end
      end

      desc 'Get all products'
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
        at_least_one_of :name, :period_num, :period_unit, :active
      end
      put ':id' do
        Product.find(params[:id]).update!(permitted_params)
      end
    end
  end
end