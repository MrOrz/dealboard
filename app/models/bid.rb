class Bid < ActiveRecord::Base
  belongs_to :deal
  belongs_to :user
  
  validates_presence_of :seq
end
