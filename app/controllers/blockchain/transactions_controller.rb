module Blockchain
  class TransactionsController < ApplicationController
    skip_forgery_protection
    before_action :set_transaction, only: %i[ show edit update destroy ]

    def build
      # TODO: If we save a record here, we could most likely monitor for matching transactions based on
      # the `operation` (transaction type) and nonce / recent blockhash. That would solve the issue of
      # FigApp users closing the browser and not sending back a tx hash or api users not broadcasting via our API
      @transaction = UnsignedTransaction.for(params[:protocol], params[:operation]).new(build_params)

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

    # GET /transactions
    def index
      @transactions = Transaction.all
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
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @transaction.errors }
        end
      end
    end

    # PATCH/PUT /transactions/1
    def update
      if @transaction.update(transaction_params)
        redirect_to @transaction, notice: "Transaction was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_entity
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
        permitted_params[:inputs].merge(network: params[:network])
      end

      def permitted_params
        params.permit(:network, inputs: {})
      end
  end
end
