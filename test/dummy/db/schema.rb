# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_02_140152) do
  create_table "blockchain_transactions", force: :cascade do |t|
    t.string "protocol"
    t.string "network"
    t.string "tx_hash"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "onchain_info"
    t.json "status_info"
    t.string "sender_address"
  end

  create_table "blockchain_unsigned_transactions", force: :cascade do |t|
    t.string "protocol"
    t.string "network"
    t.string "address"
    t.string "nonce"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "inputs"
    t.string "fingerprint"
  end
end
