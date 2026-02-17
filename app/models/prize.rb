class Prize < ApplicationRecord
  validates :name, presence: true
  validates :cost, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_count, numericality: { greater_than_or_equal_to: 0 }

  scope :in_stock, -> { where("stock_count > 0") }
end
