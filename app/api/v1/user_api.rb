module V1
  class UserAPI < Grape::API
    # use Grape::Attack::Throttle

    resource :users do
      before do
        # authenticate!
        def current_user
          User.first
        end
        def permitted_params
          @permitted_params ||= declared(params, include_missing: false).to_h
        end
      end

      desc 'Get all users'
      # throttle max: 10, per: 1.minute
      get do
        users = User.all
        present :users, users, with: API::Entities::UserEntity
      end

      desc 'Return a user'
      params do
        requires :id, type: Integer, desc: 'user id'
      end
      route_param :id do
        get do
          User.find(params[:id])
        end
      end

      desc 'Create a user'
      params do
        requires :name, type: String, desc: 'user id'
        requires :password, type: String, desc: 'user password'
        requires :password_confirmation, type: String, desc: 'user password confirmation'
        requires :email, type: String, regexp: /\A([-a-z0-9+._]){1,64}@([-a-z0-9]+[.])+[a-z]{2,}\z/, desc: 'user email'
      end
      post do
        status 200
        User.create!(permitted_params.merge({active: true}))
      end

      desc 'Update a user'
      params do
        requires :id, type: String, desc: 'user id'
        optional :password, type: String, desc: 'user password'
        optional :password_confirmation, type: String, desc: 'user password confirmation'
        optional :active, type: Boolean, desc: 'user active'
        all_or_none_of :password, :password_confirmation
        at_least_one_of :password, :password_confirmation, :active
      end
      put ':id' do
        User.find(params[:id]).update!(permitted_params)
      end
    end
  end
end