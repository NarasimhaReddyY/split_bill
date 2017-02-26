class Transaction::Share
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, type: BSON::ObjectId
  field :amount, type: Float

  belongs_to :transaction

  validates :amount, presence: true

  def member
    User.where(id: self.user_id).first
  end
end
