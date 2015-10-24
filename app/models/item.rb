class Item
  include ActiveModel::Model

  attr_accessor :id, :name, :category, :weight, :quantity, :section, :list_id

  validates :name, :category, :weight, :quantity, :section, :list_id, presence: true
end
