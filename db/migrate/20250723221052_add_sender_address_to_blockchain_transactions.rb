class AddSenderAddressToBlockchainTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :blockchain_transactions, :sender_address, :string
  end
end
