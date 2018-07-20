class SecKillJob < ApplicationJob
  queue_as :default

  def perform
    begin
      SecKill.store(LoanFeePreferential.new.call)
    rescue => e
      logger.errore e.message + e.backtrace.join("\n")
    end
  end
end
