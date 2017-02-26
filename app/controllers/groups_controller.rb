class GroupsController < ApplicationController

  def index
    @groups = Group.where(user_ids: current_user.id)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user_ids << current_user.id

    if @group.save
      redirect_to groups_url, notice: 'Group Created'
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
    @transactions = @group.transactions
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group   = Group.find(params[:id])
    user_ids = group_params[:user_ids].push(current_user.id)

    if @group.update(name: group_params[:name],
                     user_ids: user_ids)

      redirect_to groups_url, notice: 'Group Updated'
    else
      render :edit
    end
  end

  def destroy
    group = Group.find(params[:id])
    group.destroy

    redirect_to groups_url, notice: 'Group Deleted'
  end

  def transaction_summary
    @total_payments = ::TransactionSummaryGenerater.new(group_id: params[:id],
                                                        current_user: current_user)
                                                   .generate
  end

  private

  def group_params
    params.require(:group)
          .permit(:name,
                  user_ids: [])
  end
end
