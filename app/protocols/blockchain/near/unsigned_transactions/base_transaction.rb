module Blockchain::Near
  module UnsignedTransactions
    class BaseTransaction < ::Blockchain::UnsignedTransaction
      def transaction_payload
        {
          hex: response["transactionPayload"],
          base64: nil
        }
      end

      def signing_payload
        response["signingPayload"]
      end

      def nonce
        response["nonce"]
      end

      private

      def slate_networks_url
        'http://localhost:8087/near'
      end

      def headers
        {
          'Content-Type' => 'application/json',
          'x-network-name' => network,
          'x-rpc-url' => Blockchain::Near.networks[network.to_sym][:rpc_url]
        }
      end
    end
  end
end
