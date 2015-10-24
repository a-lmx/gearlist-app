class List
  include ActiveModel::Model

  attr_accessor :name, :description, :secret, :user_id

  validates :name, :user_id, presence: true
end
