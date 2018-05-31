module V1
  class UserAPI < Grape::API
    # use Grape::Attack::Throttle

    resource :users do
      # before do
      #   authenticate!
      # end

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
        User.create!(
          name: params[:name],
          email: params[:email],
          password: params[:password],
          password_confirmation: params[:password_confirmation]
        )
      end

      desc 'Update a user'
      params do
        requires :id, type: String, desc: 'user id'
        requires :password, type: String, desc: 'user password'
        requires :password_confirmation, type: String, desc: 'user password confirmation'
      end
      put ':id' do
        User.find(params[:id]).update!(
          password: params[:password],
          password_confirmation: params[:password_confirmation]
        )
      end
    end
  end
end