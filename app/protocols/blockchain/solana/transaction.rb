module Blockchain::Solana
  class Transaction
    include ActiveModel::Model

    # TODO: We could save some of this normalized info to the Transaction model for easy querying / filtering / etc

    attr_accessor :network, :hash, :status_info, :info

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

      info.dig('result', 'transaction', 'message', 'instructions')&.first&.dig('parsed', 'type') || 'unknown'
    end

    def status
      return unless status_info

      result = status_info['result']
      value = result['value'].first if result
      confirmation_status = value['confirmationStatus'] if value

      if value.nil?
        Blockchain::Status::PENDING
      elsif value['err']
        Blockchain::Status::FAILED
      elsif confirmation_status == 'finalized'
        Blockchain::Status::CONFIRMED
      elsif ['processed', 'confirmed'].include?(confirmation_status)
        Blockchain::Status::PENDING
      else
        Blockchain::Status::FAILED
      end
    end
  end
end
