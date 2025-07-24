module Blockchain
  class TransactionTrackingJob < ApplicationJob
    class TransactionPending < StandardError; end;

    retry_on TransactionPending

    queue_as :default

    def perform(transaction_id)
      transaction = Transaction.find(transaction_id)
      transaction.track

      raise TransactionPending if !transaction.completed?
    end
  end
end
