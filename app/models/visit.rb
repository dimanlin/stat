class Visit < ApplicationRecord
  has_many :page_views, dependent: :destroy

  validates :evid, format: { with: /\A[A-z0-9]{8}-[A-z0-9]{4}-[A-z0-9]{4}-[A-z0-9]{4}-[A-z0-9]{12}\z/, on: :create }

end
