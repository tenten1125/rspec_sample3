class Message < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { maximum: 50 }
  validates :context, presence: true, length: { maximum: 2000 }
end
