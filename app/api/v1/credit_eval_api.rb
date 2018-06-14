module V1
  class CreditEvalAPI < Grape::API
    resource :credit_evals do
      before do
        authenticate!
        # def current_user
        #   User.first
        # end
        def permitted_params
          @permitted_params ||= declared(params, include_missing: false).to_h
        end
      end

      desc 'Get all credit_evals'
      get do
        credit_evals = CreditEval.all
        present :credit_evals, credit_evals, with: API::Entities::CreditEvalEntity
      end

      desc 'Return credit_eval'
      params do
        requires :id, type: Integer, desc: 'credit_eval id'
      end
      route_param :id do
        get do
          credit_eval = CreditEval.find(params[:id])
          present :credit_eval, credit_eval, with: API::Entities::CreditEvalEntity
        end
      end

      desc 'Create a credit_eval'
      params do
        requires :score_gteq, type: Integer, desc: 'credit_eval score_gteq'
        requires :score_lt, type: Integer, desc: 'credit_eval score_lt'
        requires :grade, type: String, desc: 'credit_eval grade'
      end
      post do
        CreditEval.create!(permitted_params.merge({user: current_user}))
      end

      desc 'Update a credit_eval'
      params do
        requires :id, type: Integer, desc: 'credit_eval id'
        optional :score_gteq, type: Integer, desc: 'credit_eval score_gteq'
        optional :score_lt, type: Integer, desc: 'credit_eval score_lt'
        optional :grade, type: String, desc: 'credit_eval grade'
        at_least_one_of :score_gteq, :score_lt, :grade
      end
      put ':id' do
        credit_eval = CreditEval.find(params[:id])
        credit_eval.update!(permitted_params)
        credit_eval.update!(user: current_user)
      end
    end
  end
end