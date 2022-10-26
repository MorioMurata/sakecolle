class CollectionComment < ApplicationRecord
  belongs_to :user
  belongs_to :collection

  validates :comment, presence: true, length: { maximum: 100 }

end
