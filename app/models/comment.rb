class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :deal

  validates_presence_of :body
end

