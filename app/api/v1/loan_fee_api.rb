module V1
  class LoanFeeAPI < Grape::API
    resource :loan_fees do
      before do
        # authenticate!
        def current_user
          User.first
        end
      end

      desc 'Get all loan fees'
      get do
        loan_fees = LoanFee.all
        present :loan_fees, loan_fees, with: API::Entities::LoanFeeEntity
      end

      desc 'Return a loan fee'
      params do
        requires :id, type: Integer, desc: 'loan_fee id'
      end
      route_param :id do
        get do
          loan_fee = LoanFee.find(params[:id])
          present :loan_fee, loan_fee, with: API::Entities::LoanFeeEntity
        end
      end

      desc 'Create a loan fee'
      params do
        requires :product_id, type: Integer, desc: 'product id'
        requires :credit_eval_id, type: Integer, desc: 'credit_eval id'
        requires :management_fee, type: Integer, desc: 'management_fee'
        requires :times, type: Integer, desc: "times"
        optional :dayly_fee, type: Integer, desc: 'dayly_fee'
        optional :weekly_fee, type: Integer, desc: 'weekly_fee'
        optional :monthly_fee, type: Integer, desc: 'monthly_fee'
      end
      post do
        LoanFee.create!(
          product_id: params[:product_id],
          credit_eval_id: params[:credit_eval_id],
          management_fee: params[:management_fee],
          times: params[:times],
          dayly_fee: params[:dayly_fee],
          weekly_fee: params[:weekly_fee],
          monthly_fee: params[:monthly_fee],
          user: current_user,
          active: true
        )
      end

      desc 'Update a loan fee'
      params do
        requires :id, type: Integer, desc: 'loan_fee id'
        optional :product_id, type: Integer, desc: 'product id'
        optional :credit_eval_id, type: Integer, desc: 'credit_eval id'
        optional :management_fee, type: Integer, desc: 'management_fee'
        optional :times, type: Integer, desc: 'times'
        optional :dayly_fee, type: Integer, desc: 'dayly_fee'
        optional :weekly_fee, type: Integer, desc: 'weekly_fee'
        optional :monthly_fee, type: Integer, desc: 'monthly_fee'
        at_least_one_of :product_id, :credit_eval_id, :management_fee, :times, :dayly_fee, :weekly_fee, :monthly_fee
      end
      put ':id' do
        args = {
          product_id: params[:product_id],
          credit_eval_id: params[:credit_eval_id],
          management_fee: params[:management_fee],
          times: params[:times],
          dayly_fee: params[:dayly_fee],
          weekly_fee: params[:weekly_fee],
          monthly_fee: params[:monthly_fee]
        }.select{|k, v| v != nil }
        LoanFee.find(params[:id]).update!(args)
      end
    end
  end
end