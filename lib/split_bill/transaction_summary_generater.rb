class TransactionSummaryGenerater

	attr_reader :current_user

	def initialize(attributes={})
		@group_id     = attributes[:group_id]
		@current_user = attributes[:current_user]
	end

	#TODO Refacter this code later.
	def generate
    @group           = Group.find(@group_id)
    @members         = @group.members

    recieve_bills  = get_recieve_bills(@members)
    pay_bills      = get_pay_bills(@members)
    total_payments = {}

    (pay_bills.keys & recieve_bills.keys).each do |key|
      total_payments[key] =  pay_bills[key] - recieve_bills[key]
    end

    total_payments
	end

	def get_recieve_bills(members)
		_recieve_bills = {}

	  members.each do |member|
      current_user_transactions = Transaction.where(user_id: current_user.id)
                   					                  .only(:id)
                                              .map(&:id)

      member_shares  = Transaction::Share.where(transaction_id: { '$in' => current_user_transactions })
                                         .where(user_id: member.id)

      _recieve_bills[member.id.to_s] = member_shares.map(&:amount).sum
    end

    _recieve_bills
	end

	def get_pay_bills(members)
		_pay_bills = {}

	    members.each do |member|
	      member_tranactions = Transaction.where(user_id: member.id)
	                                       .only(:id)
	                                       .map(&:id)

	      current_user_shares = Transaction::Share.where(transaction_id: { '$in' => member_tranactions })
	                                     .where(user_id: current_user.id)

	      _pay_bills[member.id.to_s] = current_user_shares.map(&:amount).sum
	    end

	  _pay_bills
	end
end
