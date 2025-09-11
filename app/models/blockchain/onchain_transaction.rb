module Blockchain
  class OnchainTransaction
    include ActiveModel::Model

    # TODO: We could save some of this normalized info to the Transaction model for easy querying / filtering / etc

    attr_accessor :network, :hash, :status_info, :info

    def timestamp
      raise NotImplementedError, 'Subclass must implement timestamp'
    end

    def nonce
      raise NotImplementedError, 'Subclass must implement nonce'
    end

    def signers
      raise NotImplementedError, 'Subclass must implement signers'
    end

    def accounts
      raise NotImplementedError, 'Subclass must implement accounts'
    end

    def type
      raise NotImplementedError, 'Subclass must implement type'
    end

    def status
      raise NotImplementedError, 'Subclass must implement status'
    end

    def amount_base_units
      raise NotImplementedError, 'Subclass must implement amount_base_units'
    end

    def wallet_address
      raise NotImplementedError, 'Subclass must implement wallet_address'
    end

    def inputs
      raise NotImplementedError, 'Subclass must implement inputs'
    end
  end
end
