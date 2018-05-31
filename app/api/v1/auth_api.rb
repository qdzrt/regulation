module V1
  class AuthAPI < BaseAPI
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
          payload = {
              user: {
                  id: auth_user.id,
                  name: auth_user.name,
                  email: auth_user.email
              }
          }
          token = authorization(payload)
          {user: auth_user, token: token}
        else
          error!('Inactive', 401)
        end
      end
    end
  end
end