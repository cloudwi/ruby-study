class Article < ApplicationRecord
  has_many :comments

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }

  VALID_STATUSES = %w[public private archived]

  validates :status, inclusion: { in: VALID_STATUSES }

  def published?
    status == "archived"
  end
end
