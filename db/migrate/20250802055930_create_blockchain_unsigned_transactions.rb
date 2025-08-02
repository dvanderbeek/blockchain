class CreateBlockchainUnsignedTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :blockchain_unsigned_transactions do |t|
      t.string :protocol
      t.string :network
      t.string :address
      t.string :nonce
      t.string :source

      t.timestamps
    end
  end
end
