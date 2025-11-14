module Blockchain
  class TransactionsController < ApplicationController
    skip_forgery_protection
    before_action :set_transaction, only: %i[ show edit update destroy ]

    def build
      # TODO: This should be in the main app
      Current.user = User.find_by(id: request.headers['X-USER-ID'])

      @transaction = UnsignedTransaction.for(params[:protocol], params[:operation]).create(build_params)

      render :show, status: :created
    end

    def status
      @transaction = Transaction.new(
        tx_hash: params[:tx_hash],
        protocol: params[:protocol],
        network: params[:network],
        sender_address: params[:sender_address]
      )

      @transaction.fetch_onchain_data

      render json: { status: @transaction.onchain_tx.status.to_s }
    end

    def broadcast
      # TODO: Maybe set up a single nodejs endpoint that takes protocol as a param
      # so that we have more control over the request / response schema
      res = HTTParty.post(
        "http://localhost:3300/#{params[:protocol]}/sign-and-broadcast",
        body: {
          unsignedTransactionHex: params[:transaction_payload],
          privateKeys: [params[:private_key]],
          senderAddress: params[:sender_address],
          confirm: false
        }.to_json,
        headers: {
          "Content-Type" => "application/json"
        }
      )

      tx_hash = res["transactionHash"]

      Transaction.create(
        tx_hash:,
        protocol: params[:protocol],
        network: params[:network],
        sender_address: params[:sender_address]
      ) if tx_hash.present?

      render json: { tx_hash: }, status: :created
    end

    # GET /transactions
    def index
      @transactions = Transaction.order(created_at: :desc)
    end

    # GET /transactions/1
    def show
    end

    # GET /transactions/new
    def new
      @transaction = Transaction.new
    end

    # GET /transactions/1/edit
    def edit
    end

    # POST /transactions
    def create
      @transaction = Transaction.new(transaction_params)

      respond_to do |format|
        if @transaction.save
          format.html { redirect_to @transaction, notice: "Transaction was successfully created." }
          format.json { render json: @transaction }
        else
          format.html { render :new, status: :unprocessable_content }
          format.json { render json: @transaction.errors }
        end
      end
    end

    # PATCH/PUT /transactions/1
    def update
      if @transaction.update(transaction_params)
        redirect_to @transaction, notice: "Transaction was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_content
      end
    end

    # DELETE /transactions/1
    def destroy
      @transaction.destroy!
      redirect_to transactions_path, notice: "Transaction was successfully destroyed.", status: :see_other
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_transaction
        @transaction = Transaction.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def transaction_params
        params.expect(transaction: [ :protocol, :network, :tx_hash, :sender_address, :status ])
      end

      def build_params
        params.permit(:protocol, :network, inputs: {}).merge(source: 'API')
      end
  end
end
