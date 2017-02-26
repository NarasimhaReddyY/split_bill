class Group
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :user_ids, type: Array, default: []

  has_many :transactions

  before_save :sanitize_attributes

  validates :name, :user_ids, presence: true

  def members
    User.where(id: { '$in' => self.user_ids })
        .only(:name)
  end

  private

  def sanitize_attributes
    self.user_ids = self.user_ids.reject(&:blank?).map { |user_id| BSON::ObjectId.from_string(user_id)}
  end
end
