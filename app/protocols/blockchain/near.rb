module Blockchain::Near
  module_function

  def networks
    {
      mainnet: {
        rpc_url: 'https://archival-rpc.mainnet.near.org',
        explorer_url: 'https://nearblocks.io'
      },
      testnet: {
        rpc_url: 'https://test.rpc.fastnear.com',
        explorer_url: 'https://testnet.nearblocks.io'
      }
    }
  end
end
