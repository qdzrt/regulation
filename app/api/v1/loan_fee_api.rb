module V1
  class LoanFeeAPI < Grape::API
    resource :loan_fees do
      helpers SharedParams

      before do
        authenticate!
        # def current_user
        #   User.first
        # end
        def permitted_params
          @permitted_params ||= declared(params, include_missing: false).to_h
        end
      end

      desc '获取指定费率'
      params do
        requires :product_period, period: true, desc: 'product_period'
        requires :loan_times, type: Integer, values: [1,2], desc: 'loan_times'
        requires :credit_score, type: Integer, regexp: /\A[0-9]{1,3}\z/, desc: 'credit_score'
        optional :fee_type, type: String, values: ['management', 'dayly', 'weekly', 'monthly'], desc: 'fee_type'
      end
      get :loan_fee do
        loan_fees = LoanFeeQuery.new(params[:product_period], params[:loan_times], params[:credit_score]).call
        key = "#{params[:fee_type]}_fee"
        params[:fee_type] && loan_fees.has_key?(key) ? loan_fees[key] : loan_fees
      end

      desc '获取指定产品费率区间'
      params do
        requires :product_period, period: true, desc: 'product_period'
        requires :loan_times, type: Integer, values: [1,2], desc: 'loan_times'
        optional :fee_type, type: String, values: ['management_fee', 'dayly_fee', 'weekly_fee', 'monthly_fee'], desc: 'fee_type'
      end
      get :product_fee_interval do
        fees = ProductFeeIntervalQuery.new(params[:product_period], params[:loan_times]).call
        loan_fees = fees.inject({}) do |h, (k, v)|
          key = k.to_s
          prefix, fee_type = key[0..2], key[4..-1]
          fee = { :"#{prefix}" => v }
          h[fee_type]= h[fee_type] ? h[fee_type].deep_merge!(fee) : fee
          h
        end
        params[:fee_type] && loan_fees.has_key?(params[:fee_type]) ? loan_fees[params[:fee_type]] : loan_fees
      end

      desc '获取产品费率选项'
      get 'loan_fee_options' do
        fees = LoanFeeIntervalQuery.new.call
        fees.inject({}){|h, f| h["#{f[:period_num]}"] = "#{f[:min_fee]}% ~ #{f[:max_fee]}%"; h}
      end

      desc '获取指定条件下所有费率'
      params do
        optional :times, type: Integer, values: [1,2], desc: "times"
        optional :period, type: String, desc: "period"
        optional :score_interval, type: String, desc: "score_interval"
        use :order, order_by: %i(id created_at times), default_order_by: :id, default_order_type: :asc
        use :pagination
      end
      get do
        loan_fees = LoanFee.filter(permitted_params).page(permitted_params['page']).per(permitted_params['per'])
        present :loan_fees, loan_fees, with: API::Entities::LoanFeeEntity
        present :pagination, pagination(loan_fees), with: API::Entities::PaginationEntity
      end

      desc '获取指定费率'
      params do
        requires :id, type: Integer, desc: 'loan_fee id'
      end
      route_param :id do
        get do
          loan_fee = LoanFee.find(params[:id])
          present :loan_fee, loan_fee, with: API::Entities::LoanFeeEntity
        end
      end

      desc '添加费率'
      params do
        requires :product_id, type: Integer, desc: 'product id'
        requires :credit_eval_id, type: Integer, desc: 'credit_eval id'
        requires :management_fee, type: Integer, desc: 'management_fee'
        optional :dayly_fee, type: BigDecimal, desc: 'dayly_fee'
        optional :weekly_fee, type: BigDecimal, desc: 'weekly_fee'
        optional :monthly_fee, type: BigDecimal, desc: 'monthly_fee'
        requires :times, type: Integer, values: [1,2], fail_fast: true, desc: "times"
      end
      post do
        LoanFee.create!(permitted_params.merge({user: current_user, active: true}))
      end

      desc '更新费率'
      params do
        requires :id, type: Integer, desc: 'loan_fee id'
        optional :product_id, type: Integer, desc: 'product id'
        optional :credit_eval_id, type: Integer, desc: 'credit_eval id'
        optional :management_fee, type: Integer, desc: 'management_fee'
        optional :dayly_fee, type: BigDecimal, desc: 'dayly_fee'
        optional :weekly_fee, type: BigDecimal, desc: 'weekly_fee'
        optional :monthly_fee, type: BigDecimal, desc: 'monthly_fee'
        optional :times, type: Integer, values: [1,2], desc: 'times'
        optional :active, type: Boolean, desc: 'active'
        at_least_one_of :product_id, :credit_eval_id, :management_fee, :dayly_fee, :weekly_fee, :monthly_fee, :times, :active
      end
      put ':id' do
        loan_fee = LoanFee.find(params[:id])
        loan_fee.update!(permitted_params)
        loan_fee.update!(user: current_user)
      end
    end
  end
end