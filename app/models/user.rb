class User < ActiveRecord::Base
  validates :user_name, :presence => true
  validates :user_name, :uniqueness => true
  


end
