class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 15 }, uniqueness: { case_sensitive: false }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :icon, presence: true
  mount_uploader :icon, ImageUploader
  
  has_secure_password
  
  has_many :photoposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  has_many :favorites, dependent: :destroy
  has_many :favorite_photoposts, through: :favorites, source: :photopost
  
  def to_param
    name
  end
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_photoposts
    Photopost.where(user_id: self.following_ids + [self.id])
  end
  
  def favorite(photopost)
    self.favorites.find_or_create_by(photopost_id: photopost.id)
  end
  
  def unfavorite(photopost)
    favorite = self.favorites.find_by(photopost_id: photopost.id)
    favorite.destroy if favorite
  end
  
  def favoriting?(photopost)
    self.favorite_photoposts.include?(photopost)
  end
  
end
