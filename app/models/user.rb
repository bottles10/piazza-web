class User < ApplicationRecord
    has_many :memberships, dependent: :destroy
    has_many :organizations, through: :memberships

    has_secure_password

    validates :name, presence: true
    validates :email, 
        format: { with: URI::MailTo::EMAIL_REGEXP },
        uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: { minimum: 8 }

    normalizes :name, with: -> (name) { name.strip.capitalize }
    normalizes :email, with: -> (email) { email.strip.downcase }
end
