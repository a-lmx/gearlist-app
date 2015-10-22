class Item
  include ActiveModel::Model

  attr_accessor :name, :category, :weight, :quantity, :section

  validates :name, :category, :weight, :quantity, :section, presence: true
end
