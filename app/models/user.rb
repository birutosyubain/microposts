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

end
