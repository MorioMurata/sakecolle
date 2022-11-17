class Collection < ApplicationRecord
  has_one_attached :sake_image
  belongs_to :user
  has_many :collection_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :tags, dependent: :destroy

  validates :sake_name,presence:true, length: { maximum: 50 }

  #酒残量ステータス用enum。詳細はconfig/locales/ja.ymlへ
  enum remain_amount: { unopened: 0, percent_25: 1, percent_50: 2, percent_75: 3, finish: 4 }
  enum tastes_rich: { unselected: 0, strong: 1, light: 2 }
  enum tastes_sweet: { unpicked: 0, sweet: 1, dry: 2 }
  enum is_aromatic: { unchoosed: 0, aromatic: 1, not_aromatic: 2 }

  def get_sake_image(width, height)
    unless sake_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.png')
      sake_image.attach(io: File.open(file_path), filename: 'no_image.png', content_type: 'image/png')
    end
    sake_image.variant(resize_to_limit: [width, height]).processed
  end
  
  #開栓後何日経っているか計算
  def after_open_time
     DateTime.now.to_date  - open_date.to_date
  end
  
  #いいね（cheers）されているかの確認。views/public/favorites/_favorite_btn.html.erb内で使用
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  
  #いいね（cheers）した投稿一覧ページ内検索のための記述
  def self.looks(word)
    @collection = Collection.where("sake_name LIKE?","%#{word}%")
  end

end
