class PageView < ApplicationRecord
  belongs_to :visit

  validates :visit_id, presence: true
end