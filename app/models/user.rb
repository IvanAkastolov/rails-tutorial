class User < ApplicationRecord
  has_many :microposts, :dependent => :destroy
  validates :email, presence: true, format: /@/
  validates :name, presence: true
end
