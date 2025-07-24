class CreateBlockchainTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :blockchain_transactions do |t|
      t.string :protocol
      t.string :network
      t.string :tx_hash
      t.string :status

      t.timestamps
    end
  end
end
