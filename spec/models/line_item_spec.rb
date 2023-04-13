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
require 'rails_helper'

RSpec.describe LineItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
