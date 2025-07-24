module Blockchain
  class Rpc
    def initialize(protocol, network)
      @protocol = protocol
      @network = network
    end

    def rpc_url
      # In core, this would probably come from `Util::Network` or wherever we end up moving protocol / network config
      if @protocol == "solana" && @network == "devnet"
        URI('https://api.devnet.solana.com')
      elsif @protocol == "near" && @network == "testnet"
        URI('https://rpc.testnet.near.org')
      else
        raise NotImplementedError, "RPC URL not configured for #{@protocol} on #{@network}"
      end
    end

    def method_missing(method_name, *args, &block)
      request(method_name.to_s.camelize(:lower), args[0])
    end

    def request(method, params = [])
      uri = rpc_url

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json'

      request.body = {
        jsonrpc: '2.0',
        id: 1,
        method:,
        params:
      }.to_json

      response = http.request(request)
      JSON.parse(response.body)
    end
  end
end
