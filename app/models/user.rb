class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :collections, dependent: :destroy
  has_many :collection_comments, dependent: :destroy

  has_many :favorites, dependent: :destroy
  # has_many :favorite_collections, through: :favorites, source: :collection

  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id
  has_many :followings, through: :active_relationships, source: :follower

  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :followers, through: :passive_relationships, source: :following

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.png')
      profile_image.attach(io: File.open(file_path), filename: 'no_image.png', content_type: 'image/png')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def calculate_capacity
    stocking_capacity * 0.8
  end

  def followed_by?(user)
    passive_relationships.find_by(following_id: user.id).present?
  end

  # def hogehoge?(pass)
  #   valid_password?(pass) && !is_active
  # end

end
