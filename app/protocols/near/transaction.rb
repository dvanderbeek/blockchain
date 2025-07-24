module Near
  class Transaction
    include ActiveModel::Model

    # TODO: We could save some of this normalized info to the Transaction model for easy querying / filtering / etc

    attr_accessor :network, :hash, :status_info, :info

    def timestamp
      return unless info

      blockhash = info.dig('result', 'transaction_outcome', 'block_hash')
      block = Blockchain::Rpc.new('near', network).block({ block_id: blockhash })
      timestamp = block.dig('result', 'header', 'timestamp')
      Time.at(timestamp / 1_000_000_000)
    end

    def nonce
      return unless info

      info.dig('result', 'transaction', 'nonce')
    end

    def signers
      return unless info

      [info.dig('result', 'transaction', 'signer_id')]
    end

    def accounts
      nil
    end

    # See core's RPC pack for how this actually would work (look at txn data and figure out type, return a subclass specific to that type)
    # That subclass could also determine any follow-up tracking to figure out `activity_status`
    def type
      'unknown'
    end

    def status
      return unless status_info

      if status_info.dig('result', 'receipts_outcome', 0, 'outcome', 'status', 'SuccessValue')
        Blockchain::Status::CONFIRMED
      else
        Blockchain::Status::PENDING
      end
    end
  end
end
