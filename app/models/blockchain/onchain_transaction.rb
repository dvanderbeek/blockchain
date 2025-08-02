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

    def inputs
      raise NotImplementedError, 'Subclass must implement inputs'
    end

    def fingerprint
      data = {
        nonce:,
        address: signers.first,
        inputs:
      }

      Digest::SHA256.hexdigest data.to_json
    end
  end
end
