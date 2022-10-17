class Collection < ApplicationRecord
  has_one_attached :sake_image
  belongs_to :user
  has_many :collection_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy


  #酒残量ステータス用enum。詳細はconfig/locales/ja.ymlへ
  enum remain_amount: { unopened: 0, percent_25: 1, percent_50: 2, percent_75: 3, finish: 4 }

  def get_sake_image(width, height)
    unless sake_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.png')
      sake_image.attach(io: File.open(file_path), filename: 'no_image.png', content_type: 'image/png')
    end
    sake_image.variant(resize_to_limit: [width, height]).processed
  end

  def  after_open_time
     DateTime.now.to_date  - open_date.to_date
  end
  
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  
end
