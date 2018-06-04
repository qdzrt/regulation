module V1
  class LoanFeeAPI < Grape::API
    resource :loan_fees do
      before do
        # authenticate!
        def current_user
          User.first
        end
        def permitted_params
          @permitted_params ||= declared(params, include_missing: false).to_h
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
        optional :dayly_fee, type: BigDecimal, desc: 'dayly_fee'
        optional :weekly_fee, type: BigDecimal, desc: 'weekly_fee'
        optional :monthly_fee, type: BigDecimal, desc: 'monthly_fee'
        requires :times, type: Integer, desc: "times"
      end
      post do
        LoanFee.create!(permitted_params.merge({user: current_user, active: true}))
      end

      desc 'Update a loan fee'
      params do
        requires :id, type: Integer, desc: 'loan_fee id'
        optional :product_id, type: Integer, desc: 'product id'
        optional :credit_eval_id, type: Integer, desc: 'credit_eval id'
        optional :management_fee, type: Integer, desc: 'management_fee'
        optional :dayly_fee, type: BigDecimal, desc: 'dayly_fee'
        optional :weekly_fee, type: BigDecimal, desc: 'weekly_fee'
        optional :monthly_fee, type: BigDecimal, desc: 'monthly_fee'
        optional :times, type: Integer, desc: 'times'
        at_least_one_of :product_id, :credit_eval_id, :management_fee, :dayly_fee, :weekly_fee, :monthly_fee, :times
      end
      put ':id' do
        LoanFee.find(params[:id]).update!(permitted_params)
      end

      desc 'Get product loan fee interval'
      get 'loan_fee_options' do

      end

      desc 'Fetch product loan fees interval'
      params do
        requires :product_period, type: String, desc: 'product_period'
        requires :loan_times, type: Integer, values: [1,2], desc: 'loan_times'
        optional :fee_type, type: String, values: ['management_fee', 'dayly_fee', 'weekly_fee', 'monthly_fee'], desc: 'fee_type'
      end
      get 'product_fee_interval' do
        ProductFee.product_fee_interval(params)
      end
    end
  end
end