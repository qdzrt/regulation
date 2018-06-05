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

      desc '获取费率区间'
      params do
        requires :product_period, types: [Integer, String], desc: 'product_period'
        requires :loan_times, type: Integer, values: [1,2], desc: 'loan_times'
        optional :fee_type, type: String, values: ['management', 'dayly', 'weekly', 'monthly'], desc: 'fee_type'
      end
      get :product_fee_interval do
        fees = ProductFeeIntervalQuery.new(params[:product_period], params[:loan_times]).call
        loan_fees = fees.inject({}) do |h, f|
          fd = f[0].dup
          fee_type = fd.sub(/(min|max)_/, '')
          prefix = fd.split('_')[0]
          h[fee_type] ? h[fee_type].deep_merge!({ "#{prefix}" => f[1] }) : h[fee_type]={ "#{prefix}" => f[1] }
          h
        end
        key = "#{params[:fee_type]}_fee"
        params[:fee_type] && loan_fees.has_key?(key) ? loan_fees[key] : loan_fees
      end

      desc '获取产品费率选项'
      get 'loan_fee_options' do
        fees = LoanFeeIntervalQuery.new.call
        fees.inject({}){|h, f| h["#{f[:period_num]}"] = "#{f[:min_fee]}% ~ #{f[:max_fee]}%"; h}
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
    end
  end
end