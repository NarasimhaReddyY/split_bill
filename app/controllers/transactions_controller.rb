class TransactionsController < ApplicationController

  before_action :set_paid_date, only: [:create, :update]

  def new
    @group       = Group.find(params[:group_id])
    @transaction = @group.transactions.new

    @group.user_ids.each do |user_id|
      @transaction.shares.build(user_id: user_id)
    end

    @transaction
  end

  def create
    @group       = Group.find(params[:group_id])
    @transaction = @group.transactions.new(transaction_params.merge(user_id: current_user.id, paid_date: @paid_date))

    if @transaction.save
      redirect_to group_url(@group), notice: 'Transaction created'
    else
      render :new
    end
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  def edit
    @group       = Group.find(params[:group_id])
    @transaction = @group.transactions.find(params[:id])
  end

  def update
    @group       = Group.find(params[:group_id])
    @transaction = @group.transactions.find(params[:id])

    if @transaction.update(transaction_params.merge(paid_date: @paid_date))
      redirect_to group_url(@group), notice: 'Transaction updated'
    else
      render :edit
    end
  end

  private

  def transaction_params
    params.require(:transaction)
          .permit(:amount,
                  :comment,
                  shares_attributes: [:id, :user_id, :amount])
  end

  def set_paid_date
    @paid_date = Date.new(params[:transaction]["paid_date(1i)"].to_i,
                          params[:transaction]["paid_date(2i)"].to_i,
                          params[:transaction]["paid_date(3i)"].to_i)

  end
end
