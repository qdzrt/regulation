class ProductFee
  extend ActiveSupport::Concern

  inclued do
    include InstanceMethods
  end

  module InstanceMethods

  end

  module ClassMethods
    def product_fee_interval(params = {})
      loan_fees_table
        .project()
    end
  end

  private

  def loan_fees_table
    @loan_fees_table ||= LoanFee.arel_table
  end

  def interval

  end


end