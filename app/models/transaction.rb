class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps

  field :amount, type: Float
  field :user_id, type: BSON::ObjectId
  field :comment, type: String
  field :paid_date, type: DateTime
  field :group_id, type: BSON::ObjectId

  belongs_to :group
  belongs_to :user

  has_many :shares, class_name: 'Transaction::Share'

  accepts_nested_attributes_for :shares, allow_destroy: true

  validate :shares_amount
  validates :amount, :paid_date, presence: true

  private

  def shares_amount
    return if self.shares.map(&:amount).compact.sum == self.amount
    self.errors.add(:amount, "Shares sum should be equal to Transaction amount")
  end
end
