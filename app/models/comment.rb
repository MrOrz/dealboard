class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :code
  
  validates_presence_of :body
end
