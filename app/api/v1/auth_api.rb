module V1
  class AuthAPI < Grape::API
    resources :auth do
      helpers do
        def auth_user
          User.authorize!(params)
        end
      end

      before do
        error!('Unauthorized!', 401) unless auth_user
      end

      desc 'authoriztion'
      params do
        requires :name, type: String, desc: 'auth name'
        requires :password, type: String, desc: 'auth password'
      end
      post :token do
        if auth_user && auth_user.active
          token = JsonWebToken.encode({user_id: auth_user.id})
          {user: auth_user, token: token}
        else
          error!('Inactive', 401)
        end
      end
    end
  end
end