class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :collections, dependent: :destroy
  has_many :collection_comments, dependent: :destroy

  has_many :favorites, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id, dependent: :destroy
  has_many :followings, through: :active_relationships, source: :follower, dependent: :destroy

  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :following, dependent: :destroy

  validates :user_name, presence:true, length: { maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.png')
      profile_image.attach(io: File.open(file_path), filename: 'no_image.png', content_type: 'image/png')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  #設定された在庫上限の８割を超えているかどうかの確認。helpers/public/application_helper.rb内で使用。
  def calculate_capacity
    stocking_capacity = self.stocking_capacity.nil? ? 0 : self.stocking_capacity
    stocking_capacity * 0.8
  end
  
  def followed_by?(user)
    passive_relationships.find_by(following_id: user.id).present?
  end
  
  #退会済みユーザーを弾くメソッド
  def active_for_authentication?
    super && (is_deleted == false)
  end
  
  #ゲストユーザーの情報を与えるメソッド
  def self.guest
    find_or_create_by!(user_name: 'guestuser' ,email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.user_name = "guestuser"
    end
  end
  
  #ゲストユーザーかどうかを判定するメソッド
  def is_guest?
    return email == "guest@example.com"
  end
  
  #ユーザー一覧ページ内検索のための記述
  def self.looks(word)
    @user = User.where("user_name LIKE?","%#{word}%")
  end

end
