class Deal < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  acts_as_taggable_on :tags
  
  validates_uniqueness_of :title
  
  def to_url
    self.title.gsub(/ /,'-')
  end
end