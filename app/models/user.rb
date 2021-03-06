class User < ActiveRecord::Base
  attr_accessible :username, :session_token, :password, :password_confirmation, :email
  has_secure_password

  has_many :secrets
  has_many :shares_secrets_to, :class_name => "Sharing", :foreign_key => :sharer_id
  has_many :friends, :through => :shares_secrets_to

  has_many :gets_secrets, :class_name => "Sharing", :foreign_key => :friend_id
  has_many :sharers, :through => :gets_secrets

  validates :email, :format => { :with => /^\S+@\S+$/,
            :message => "Fix yo email, yo." },
            :presence => true
  validates :username, :uniqueness => true, :presence => true
  validates :password, :length => { :in =>  8..16,
              :message => "must be 8-16 characters"},
            :format => { :with => /[A-Za-z]\w+\d+/,
              :message => "must start with a letter and also contain numbers"},
            :presence => true





  def reset_token
    token = SecureRandom.hex
    if self.update_attribute(:session_token, token)
      token
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      false
    end
  end

  def delete_token
    self.update_attribute(:session_token, nil)
  end

end
