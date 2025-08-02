module Blockchain::Solana
  class Transaction < Blockchain::OnchainTransaction
    def timestamp
      return unless info && info.dig('result', 'blockTime')

      Time.zone.at info.dig('result', 'blockTime')
    end

    def nonce
      return unless info

      info.dig('result', 'transaction', 'message', 'recentBlockhash')
    end

    def signers
      return unless accounts

      accounts&.select { |key| key['signer'] }&.map { |signer| signer['pubkey'] }
    end

    def accounts
      return unless info

      info.dig('result', 'transaction', 'message', 'accountKeys')
    end

    # See core's RPC pack for how this actually would work (look at txn data and figure out type, return a subclass specific to that type)
    # That subclass could also determine any follow-up tracking to figure out `activity_status`
    def type
      return unless info

      type = info.dig('result', 'transaction', 'message', 'instructions')&.first&.dig('parsed', 'type') || 'unknown'

      case type
      when 'createAccount' then 'stake'
      else type
      end
    end

    # Subclass also needs to know how to reconstruct inputs so that we can calculate fingerprint
    # Keys match the inputs that the API expects when building the tx payload for app/protocols/blockchain/solana/unsigned_transactions/stake_transaction.rb
    # For now, this only works for stake transactions
    # Need keys to be in the same order as in the unsigned tx; we should sort them in both places
    def inputs
      wallet_address = info.dig('result', 'transaction', 'message', 'instructions')&.first&.dig('parsed', 'info', 'source')
      amount = info.dig('result', 'transaction', 'message', 'instructions')&.first&.dig('parsed', 'info', 'lamports')
      validator_address = info.dig('result', 'transaction', 'message', 'instructions')&.last&.dig('parsed', 'info', 'voteAccount')

      return {} unless wallet_address && amount && validator_address

      {
        wallet_address:,
        validator_address:,
        amount: (amount / 10**9).to_f
      }
    end

    def status
      return unless status_info

      result = status_info['result']
      value = result['value'].first if result
      confirmation_status = value['confirmationStatus'] if value

      return Blockchain::Status::PENDING if value.nil?
      return Blockchain::Status::FAILED if value['err']
      return Blockchain::Status::CONFIRMED if confirmation_status == 'finalized'

      if current_block_height && value['slot']
        if current_block_height > value['slot'] + 150
          return Blockchain::Status::EXPIRED
        end
      end

      if ['processed', 'confirmed'].include?(confirmation_status)
        Blockchain::Status::PENDING
      else
        Blockchain::Status::FAILED
      end
    end

    def current_block_height
      @current_block_height ||= Blockchain::Rpc.new('solana', network).get_block_height([
        { commitment: 'finalized' }
      ])['result']
    end
  end
end
