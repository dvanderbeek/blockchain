class AddOnchainInfoToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :blockchain_transactions, :onchain_info, :json
    add_column :blockchain_transactions, :onchain_status, :json
  end
end
