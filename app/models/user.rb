# frozen_string_literal: true

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable, :recoverable, 
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable,
         :rememberable, :trackable, :validatable, :authentication_keys => [:email], jwt_revocation_strategy: self

  ## Database authenticatable
  # field :_id, type: String, default: ->{ username }
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  # field :reset_password_token,   type: String
  # field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  ## JWT
  field :jti, type: String, default: "" # Only if lock strategy is :failed_attempts

  ## Information
  field :full_name, type: String, default: ""
  
  ## Validation
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :full_name, presence: true
  validates :full_name, length: { minimum: 2 }
  validates :jti, uniqueness: true

  ## Associations
  has_many :my_links
  
  ##
  # def email_required?
  #   true
  # end
  # def email_changed?
  #   true
  # end
  def self.primary_key
    '_id'
  end

  def self.revoke_jwt(_payload, user)
    user.update_attribute(:jti, generate_jti)
  end

  def object_after_login
    {
      user: {
        g_id: self.to_sgid(expires_in: nil, for: 'authentication').to_s,
        jti: jti
      }
    }
  end
end
