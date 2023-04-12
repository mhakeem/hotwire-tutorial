# == Schema Information
#
# Table name: line_item_dates
#
#  id         :bigint           not null, primary key
#  date       :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quote_id   :bigint           not null
#
# Indexes
#
#  index_line_item_dates_on_date               (date)
#  index_line_item_dates_on_date_and_quote_id  (date,quote_id) UNIQUE
#  index_line_item_dates_on_quote_id           (quote_id)
#
# Foreign Keys
#
#  fk_rails_...  (quote_id => quotes.id)
#
require 'rails_helper'

RSpec.describe LineItemDate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
