class User < ApplicationRecord 

    validates :username, :session_token, presence: true, uniqueness: true 
    validates :password_digest, presence: true 
    validates :password, presence: true, length: {minimum: 6}, allow_nil: true 

    has_many :cats, 
    class_name: :Cat, 
    primary_key: :id, 
    foreign_key: :user_id 

    has_many :requests,
    class_name: :CatRentalRequest,
    primary_key: :id,
    foreign_key: :requester_id

    after_initialize :ensure_session_token
    attr_reader :password

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        if user && user.is_password?(password)
            return user 
        else
            return nil
        end
    end

    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64
    end

    def reset_session_token! 
        self.session_token = SecureRandom::urlsafe_base64
        self.save!
        self.session_token 
    end

    def password=(password)
        @password = password 
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    

end