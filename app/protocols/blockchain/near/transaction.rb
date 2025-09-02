module Blockchain::Near
  class Transaction < Blockchain::OnchainTransaction
    def timestamp
      return unless info

      info.dig('timestamp')
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
      'stake'
    end

    def amount_base_units
      return unless info

      info.dig('result', 'transaction', 'actions', 0, 'FunctionCall', 'deposit')
    end

    def wallet_address
      return unless info

      info.dig('result', 'transaction', 'signer_id')
    end

    def wallet_pubkey
      return unless info

      info.dig('result', 'transaction', 'public_key')
    end

    def validator_address
      return unless info

      info.dig('result', 'transaction', 'receiver_id')
    end

    # Subclass also needs to know how to reconstruct inputs so that we can calculate fingerprint
    # Keys match the inputs that the API expects when building the tx payload for app/protocols/blockchain/solana/unsigned_transactions/stake_transaction.rb
    # For now, this only works for stake transactions
    # Need keys to be in the same order as in the unsigned tx; we should sort them in both places
    def inputs
     {
        wallet_address:,
        wallet_pubkey:,
        validator_address:,
        amount: (amount_base_units.to_d / 10**24).to_f
      }.stringify_keys
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
