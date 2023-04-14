# frozen_string_literal: true

# == Schema Information
#
# Table name: line_items
#
#  id                :bigint           not null, primary key
#  description       :text
#  name              :string           not null
#  quantity          :integer          not null
#  unit_price        :decimal(10, 2)   not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  line_item_date_id :bigint           not null
#
# Indexes
#
#  index_line_items_on_line_item_date_id  (line_item_date_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_item_date_id => line_item_dates.id)
#
class LineItem < ApplicationRecord
  belongs_to :line_item_date

  validates :name, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than: 0 }

  delegate :quote, to: :line_item_date

  def total_price
    quantity * unit_price
  end
end
