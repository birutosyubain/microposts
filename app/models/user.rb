class User < ActiveRecord::Base
    before_save { self.email = email.downcase }
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                                      format: { with: VALID_EMAIL_REGEX },
                                      uniqueness: { case_sensitive: false }
    has_secure_password
    
    # プロフィールは2文字以上, 100文字以下, 未入力_OK
    validates :profile, length: { minimum: 2, maximun: 100 }, :allow_blank => true
    # 地域は2文字以上, 50文字以下, 未入力_OK
    validates :area, length: { minimum: 2, maximun: 50 }, :allow_blank => true
    
    has_many :microposts
    
    has_many :following_relationships, class_name:  "Relationship",
                                       foreign_key: "follower_id",
                                       dependent:   :destroy
    has_many :following_users, through: :following_relationships, source: :followed
    
    has_many :follower_relationships, foreign_key: "followed_id",
                                      class_name:  "Relationship",
                                      dependent:   :destroy
    has_many :follower_users, through: :follower_relationships, source: :follower
    
    # 他のユーザーをフォローする
    def follow(other_user)
      following_relationships.create(followed_id: other_user.id)
    end

    # フォローしているユーザーをアンフォローする
    def unfollow(other_user)
      following_relationships.find_by(followed_id: other_user.id).destroy
    end

    # あるユーザーをフォローしているかどうか？
    def following?(other_user)
      following_users.include?(other_user)
    end
    
    def feed_items
      Micropost.where(user_id: following_user_ids + [self.id])
    end

end
