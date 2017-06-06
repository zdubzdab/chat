class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true,
                   length: { minimum: 2 },
                   uniqueness: true
  validates :email, presence: true,
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
                              message: 'bad format' }, uniqueness: true
  validates :password, confirmation: true
  validates_length_of :password, in: 6..15, on: :create
end
